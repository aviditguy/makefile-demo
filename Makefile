#compiler flags and options
CC := gcc
CFLAGS := -std=c11 -Wall -Werror -Wextra -pedantic
LDFLAGS := -lm

#default target
.DEFAULT_GOAL := all

#directories
SRC_DIR := source
INC_DIR := include
BUILD_DIR := build
RELEASE_DIR := $(BUILD_DIR)/release
DEBUG_DIR := $(BUILD_DIR)/debug

#binary names
RELEASE_BIN := $(RELEASE_DIR)/app
DEBUG_BIN := $(DEBUG_DIR)/app

#source file names
SRCS := $(wildcard $(SRC_DIR)/*.c)

#object file names
RELEASE_OBJS := $(patsubst $(SRC_DIR)/%.c, $(RELEASE_DIR)/%.o, $(SRCS))
DEBUG_OBJS := $(patsubst $(SRC_DIR)/%.c, $(DEBUG_DIR)/%.o, $(SRCS))

#printing srcs and object files
$(warning srcs = $(SRCS))
$(warning release_objs = $(RELEASE_OBJS))
$(warning debug_objs = $(DEBUG_OBJS))

#build binaries
$(RELEASE_BIN): $(RELEASE_OBJS) | $(RELEASE_DIR)
	$(CC) $^ $(LDFLAGS) -o $@
$(DEBUG_BIN): $(DEBUG_OBJS) | $(DEBUG_DIR)
	$(CC) $^ $(LDFLAGS) -o $@

#build release object files
$(RELEASE_DIR)/main.o: $(SRC_DIR)/main.c $(INC_DIR)/point.h $(INC_DIR)/rect.h | $(RELEASE_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
$(RELEASE_DIR)/point.o: $(SRC_DIR)/point.c $(INC_DIR)/point.h | $(RELEASE_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
$(RELEASE_DIR)/rect.o: $(SRC_DIR)/rect.c $(INC_DIR)/point.h $(INC_DIR)/rect.h | $(RELEASE_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

#build debug object files
$(DEBUG_DIR)/main.o: $(SRC_DIR)/main.c $(INC_DIR)/point.h $(INC_DIR)/rect.h | $(DEBUG_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
$(DEBUG_DIR)/point.o: $(SRC_DIR)/point.c $(INC_DIR)/point.h | $(DEBUG_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
$(DEBUG_DIR)/rect.o: $(SRC_DIR)/rect.c $(INC_DIR)/point.h $(INC_DIR)/rect.h | $(DEBUG_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

#create directories
$(RELEASE_DIR):
	mkdir -p $@
$(DEBUG_DIR):
	mkdir -p $@

#phony targets
.PHONY: all release debug run clean

all: release debug

release: CFLAGS += -O3
release: $(RELEASE_BIN)

debug: CFLAGS += -g -O0
debug: $(DEBUG_BIN)

run:
	@if [ -f $(DEBUG_BIN) ]; then	\
		./$(DEBUG_BIN);	\
	else	\
		./$(RELEASE_BIN);	\
	fi

clean:
	rm -rf $(RELEASE_DIR) $(DEBUG_DIR)
