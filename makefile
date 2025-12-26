#==============================================================================#
# Compiler & flags
#==============================================================================#
CC            := gcc

# Include paths
CLIENTFLAGS   := -Iclient -Ilinux -Iqcommon -Iref_gl
SERVERFLAGS   := -Iserver -Ilinux -Iqcommon

# Compile flags
DEBUGFLAGS    := -g -O0
RELEASEFLAGS  := -O3

# Link flags
CLIENTLDFLAGS := -lGL -lGLU -lm
SERVERLDFLAGS := -lm

#==============================================================================#
# Source files
#==============================================================================#
CLIENTSRC := $(shell find client   -name "*.c")
SERVERSRC := $(shell find server   -name "*.c")
COMMONSRC := $(shell find qcommon  -name "*.c")
GLSRC     := $(shell find ref_gl   -name "*.c")
LINUXSRC  := $(shell find linux    -name "*.c")

# Object files
CLIENTOBJ := $(CLIENTSRC:client/%.c=build/client/%.o)
SERVEROBJ := $(SERVERSRC:server/%.c=build/server/%.o)
COMMONOBJ := $(COMMONSRC:qcommon/%.c=build/qcommon/%.o)
GLOBJ     := $(GLSRC:ref_gl/%.c=build/ref_gl/%.o)
LINUXOBJ  := $(LINUXSRC:linux/%.c=build/linux/%.o)

#==============================================================================#
# Build types
#==============================================================================#
debug: CFLAGS := $(DEBUGFLAGS)
debug: client

release: CFLAGS := $(RELEASEFLAGS)
release: client

#==============================================================================#
# Targets
#==============================================================================#
client: $(CLIENTOBJ) $(COMMONOBJ) $(GLOBJ) $(LINUXOBJ)
	@mkdir -p bin
	$(CC) $^ -o bin/client $(CLIENTLDFLAGS)

server: $(SERVEROBJ) $(COMMONOBJ) $(LINUXOBJ)
	@mkdir -p bin
	$(CC) $^ -o bin/server $(SERVERLDFLAGS)

clean:
	rm -rf bin
	rm -rf build

#==============================================================================#
# Rules for objects
#==============================================================================#
build/client/%.o: client/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(CLIENTFLAGS) -c $< -o $@

build/server/%.o: server/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(SERVERFLAGS) -c $< -o $@

build/ref_gl/%.o: ref_gl/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -Iref_gl -c $< -o $@

build/qcommon/%.o: qcommon/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -Iqcommon -c $< -o $@

build/linux/%.o: linux/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -Ilinux -c $< -o $@

#==============================================================================#