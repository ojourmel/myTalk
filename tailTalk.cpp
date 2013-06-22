#include <iostream>
#include <fstream>
#include <string.h>
#include <sys/inotify.h>
#include <cstdlib>
#include <list>
#include <vector>

using namespace std;

void getString(string fileName);

string lastMessage;
vector<string> messageArray;

int main( int argc, const char* argv[] )
{
   int watch = inotify_init();
   const size_t buf_size = sizeof(struct inotify_event);

   string fileName = argv[1];

   inotify_add_watch(watch, fileName.c_str(), IN_MODIFY);

   char buf[buf_size]; 

   while(read(watch, buf, buf_size)>= 0)
   {
      getString(fileName);
   }

}

void getString(string fileName)
{
   ifstream Test;
   Test.open(fileName.c_str(), std::ios_base::ate );//open file
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
         cout << tmp << endl; // print it
         lastMessage = tmp;
      }
   }
}


