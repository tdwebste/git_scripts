#auto generate TARGET NAME
#TARGET_EXEC ?= a.out
# make CHIBIOS=~/src/ChibiOS print-CHIBIOS
ifndef CHIBIOS
    CHIBIOS = $$HOME/src/ChibiOS
endif

BUILD_DIR ?= ./build
SRC_DIRS ?= $(shell ls -d src 2>/dev/null || echo '.')
SRC_BASE ?= $(shell ls -d src || echo '')
#SRC_DIRS ?= ./src
TARGET_EXEC ?= $(notdir $(shell grep -l 'int main' ${SRC_BASE}/*.c))

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# assembly
$(BUILD_DIR)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	$(MKDIR_P) $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p
print-%  : ; @echo $* = $($*)

