#include <iostream>
#include <fstream>
#include <string.h>
#include <sys/inotify.h>
#include <unistd.h>
#include <cstdlib>
#include <list>
#include <vector>
#include <thread>

using namespace std;

void getString(string fileName);
void listen(string FileNamePointer);
void speak();

string lastMessage;
vector<string> messageArray;

int main( int argc, const char* argv[] )
{

   string fileName = argv[1];
   pthread_t threads[NUM_THREADS];
   
   thread listenerThread(listen, fileName);
   thread speakerThread(speak);
 
   listenerThread.join();
   speakerThread.join();
   
}

void getString(string fileName)
{
   ifstream Test;
   Test.open(fileName.c_str(), std::ios_base::ate );//open file and set position to end of the file
   string tmp;
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
         tmp = messageArray.back();
         messageArray.pop_back();
         printf("%s \n",tmp.c_str()); // print it
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
      message = "~/.myTalk/myt " + message;
      system(message.c_str());
   }
}
