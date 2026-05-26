ROOT := $(realpath $(dir $(firstword $(MAKEFILE_LIST)))/..)
OCCT_INSTALL := $(ROOT)/.local
CXXFLAGS := -fPIC -std=c++17 -MMD -I$(OCCT_INSTALL)/include/opencascade
LDFLAGS := -shared -L$(OCCT_INSTALL)/lib
LIBS := -lTKernel -lTKMath -lTKG2d -lTKG3d -lTKBRep -lTKPrim -lTKBool \
        -lTKDESTEP -lTKXSBase -lTKDESTL -lTKMesh -lTKXCAF -lTKCAF \
        -lTKDEGLTF -lTKDEIGES -lTKDEVRML -lTKDEPLY -lTKDEOBJ -lTKRWMesh \
        -lTKV3d -lTKOpenGl -lTKService -lTKHelix -lTKFillet -lTKOffset -lTKFeat -lTKMeshVS \
        -Wl,--enable-new-dtags -Wl,-rpath,$(OCCT_INSTALL)/lib

SRCS := $(wildcard occt_wrap_*.cpp)
OBJS := $(SRCS:.cpp=.o)
DEPS := $(OBJS:.o=.d)
TARGET := ../lib/libocctwrap.so

.PHONY: all clean

all: $(TARGET)

-include $(DEPS)

$(TARGET): $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $^ $(LIBS)

occt_wrap_%.o: occt_wrap_%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)
