
#include <stdio.h>
#include <dlfcn.h>
#include <SC_PlugIn.h>

#include <ios>
#include <fstream>

#include <ctime>
#include <iostream>

bool defu(const char *inName, size_t inAllocSize, UnitCtorFunc inCtor, UnitDtorFunc inDtor, uint32 inFlags)
{
  std::ofstream log("/tmp/main.log", std::ios_base::app | std::ios_base::out);
  
  std::time_t result = std::time(nullptr);
  log << "ctor " << std::asctime(std::localtime(&result)) << "";

  printf("main.cpp: defu\n");
  std::cout << "foo";
  return true;
}

bool defu2(const char *inName, size_t inAllocSize, uint32 inFlags)
{
  std::ofstream log("/tmp/main.log", std::ios_base::app | std::ios_base::out);
  
  std::time_t result = std::time(nullptr);
  log << "ctor " << std::asctime(std::localtime(&result)) << "";

  printf("main.cpp: defu2\n");
  std::cout << "foo";
  return true;
}

bool defu3(const char *inName, UnitCtorFunc inCtor, size_t inAllocSize, uint32 inFlags)
{
  std::ofstream log("/tmp/main.log", std::ios_base::app | std::ios_base::out);
  
  std::time_t result = std::time(nullptr);
  log << "ctor " << std::asctime(std::localtime(&result)) << "";

  printf("main.cpp: defu3\n");
  std::cout << "foo";
  return true;
}


void defum()
{
  std::ofstream log("/tmp/main.log", std::ios_base::app | std::ios_base::out);
  
  std::time_t result = std::time(nullptr);
  log << "ctor " << std::asctime(std::localtime(&result)) << "";

  printf("main.cpp: defum\n");
  std::cout << "foo";
}

int main() {
  void *handle;

  handle = dlopen ("/home/carlo/OscarUGens/OscarUGens.so", RTLD_NOW);
  void *ptr = dlsym(handle, "load");
  if (!ptr) {
    std::string c = dlerror();
    printf("main.cpp: dlsym load err '%s'\n", c);
    dlclose(handle);
    return false;
  }

  LoadPlugInFunc loadFunc = (LoadPlugInFunc)ptr;
  
  printf("main.cpp: loadFunc address: %i\n", loadFunc);
  
  InterfaceTable ft;
  ft.fDefineUnit = &defu;
  printf("main.cpp: InterfaceTable address: %i\n", &ft);
  printf("main.cpp: fDefineUnit address: %i\n", ft.fDefineUnit);
  
  //printf("main.cpp: exec direct first\n");
  //ctor();

  printf("main.cpp: exec dynamically loaded\n");
  (*loadFunc)(&ft);
  
  //printf("main.cpp: exec direct second\n");
  //defu();
}

