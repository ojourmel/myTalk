#include <iostream>
#include <fstream>
#include <string.h>
#include <sys/inotify.h>
#include <unistd.h>
#include <cstdlib>
#include <list>
#include <vector>
#include <thread>
#include <signal.h>

using namespace std;

void getString(string fileName);
void listen(string FileNamePointer);
void speak();
void cleanup(int bs);

string lastMessage;
vector<string> messageArray;

int main( int argc, const char* argv[] )
{
   // Remember to "log off" if things die
   signal(SIGTERM, cleanup);
   signal(SIGHUP, cleanup);
   signal(SIGINT, cleanup);
   
   string fileName = argv[1];
   
   thread listenerThread(listen, fileName);
   thread speakerThread(speak);
 
   listenerThread.join();
   speakerThread.join();
   
}

void getString(string fileName)
{
   ifstream Test;
   Test.open(fileName.c_str(), std::ios_base::ate );//open file and set position to end of the file
   string tmp,tmp2;
   int length = 0;
   int failsafe = 0;
   char c = '\0';

   if( Test )
   {
      length = Test.tellg();//Get file size

      // loop backward over the file

      for(int i = length-2; i > 0; i-- )
      {
         Test.seekg(i);
         c = Test.get();
         if(c == '\n' )//new line?
         {

            std::getline(Test, tmp);
            messageArray.push_back(tmp);
            failsafe++;

            if(failsafe > 10)
            {
               break;
            }

            if(messageArray.back() == lastMessage)
            {
               messageArray.pop_back();
               break;    
            }
         }
      }

      while(!messageArray.empty())
      {
         tmp = messageArray.back(); //peek
         messageArray.pop_back(); //pop
         tmp2 = tmp.substr (0,2); //get the color
         printf("\033[%sm %s \033[0m\n",tmp2.cstr(),tmp.c_str());//print it with color 
         fflush(stdout); // flush buffers
         lastMessage = tmp;
      }
   }
}

void listen(string fileName)
{
   
   int watch = inotify_init();
   const size_t buf_size = sizeof(struct inotify_event);

   inotify_add_watch(watch, fileName.c_str(), IN_MODIFY);

   char buf[buf_size]; 

   while(read(watch, buf, buf_size)>= 0)
   {
      getString(fileName);
   }
}

void speak()
{
   string message;

   while(getline(cin , message))
   {
      if(message != ""){

         string escapeString=""; 
         int count=0;

         for(int i = 0; i<message.size(); i++){
            switch(message[i]){
               case '\\':
                  escapeString.push_back('\\');
                  escapeString.push_back('\\');
               case '\"':
                  escapeString.push_back('\\');
                  escapeString.push_back('\"'); break;
               default: escapeString.push_back(message[i]);
            }
         }
        
         message = "~/.myTalk/myt \"" + escapeString + "\"";
         system(message.c_str());
      }
   }
}

void cleanup(int bs)
{
   static int isclean;
   // Only die once...
   if(!isclean)
   {
      isclean = 1;
   
      // Clean tail, print logoff, cout die
      system("~/.myTalk/myt quit: logging off");

      system("killall tail 2> /dev/null");
      cout << "tailTalk killed" << endl;

   }
   
   exit(50);

}
