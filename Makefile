# 设置变量
APP_NAME := myapp
OUT_DIR := build
ADB_PATH := adb
DEVICE_PATH := /data/local/tmp
PLATFORMS := $(shell cat configs/platforms.ini)
MAIN_FILE := $(shell find ./cmd -type f -name "main.go")
BINS := $(wildcard build/android_*/*)
# 默认目标
all: build

# 清理生成的文件
clean:
	@rm -rf $(OUT_DIR)
	@echo "Cleaned build directory."

# 推送到设备
push: build
	@for BIN in $(BINS); do \
		file=$$(basename $$(dirname $$BIN)); \
		echo "Pushing $$file"; \
		$(ADB_PATH) push $$BIN $(DEVICE_PATH)/$$file; \
	done

# 运行程序
run: push
	@$(ADB_PATH) shell $(DEVICE_PATH)/$(APP_NAME)
build: clean
	@for plat in $(PLATFORMS); do \
		platform=$$(echo $$plat | cut -d ',' -f 1); \
		arch=$$(echo $$plat | cut -d ',' -f 2); \
		for main in $(MAIN_FILE); do \
			program=$$(basename $$(dirname $$main)); \
			echo "Processing platform: $$platform arch: $$arch program: $$program"; \
			GOOS=$$platform GOARCH=$$arch go build -o $(OUT_DIR)/$${platform}_$${arch}/$$program $$main; \
		done;\
	done
# 帮助信息
help:
	@echo "Makefile Usage:"
	@echo "  make build       - Build the application for all architectures."
	@echo "  make clean       - Clean up the build directory."
	@echo "  make push        - Push the ARM64 binary to the Android device."
	@echo "  make run         - Push and run the application on the Android device."
	@echo "  make help        - Show this help message."
