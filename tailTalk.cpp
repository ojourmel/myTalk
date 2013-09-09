#include <iostream>
#include <fstream>
#include <string.h>
#include <sys/inotify.h>
#include <unistd.h>
#include <cstdlib>
#include <list>
#include <vector>
#include <pthread.h>


#define NUM_THREADS 2








using namespace std;



void getString(string fileName);
void *listen(void* fileNamePointer);
void *speak(void* TESTPOINTERPLEASEIGNORE);


string lastMessage;
vector<string> messageArray;





int main( int argc, const char* argv[] )
{

   int listenerThreadError = 0;
   int speakerThreadError = 0;

   string fileName = argv[1];
   pthread_t threads[NUM_THREADS];
   
   listenerThreadError = pthread_create(&threads[0], NULL, listen, (void *)fileName.c_str() );
   speakerThreadError = pthread_create(&threads[1], NULL, speak, NULL );
 
   
   
   if (listenerThreadError)
   {
      cout << "Error:unable to create thread 0" << endl;
      exit(-1);
   }
   
   if (speakerThreadError)
   {
      cout << "Error:unable to create thread 1" << endl;
      exit(-1);
   }
   
   
   pthread_exit(NULL);
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

void *listen(void* fileNamePointer)
{
   
   string fileName = (char*)fileNamePointer;

   int watch = inotify_init();
   const size_t buf_size = sizeof(struct inotify_event);

   

   inotify_add_watch(watch, fileName.c_str(), IN_MODIFY);

   char buf[buf_size]; 

   while(read(watch, buf, buf_size)>= 0)
   {
      getString(fileName);
   }

   pthread_exit(NULL);
}


void *speak(void* TESTPOINTERPLEASEIGNORE)
{

   string message;

   while(cin >> message)
   {
      message = "~/.myTalk/myt " + message;
      system(message.c_str());
   
   }

   pthread_exit(NULL);
}


