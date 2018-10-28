OUT ?= $(abspath wwwroot)
PORT ?= 8000
TARGET ?= $(abspath tmp)
TMP ?= $(abspath tmp)

datetime := $(shell date '+%Y-%m-%dT%H:%M:%S%z')

.PHONY : all
all : \
		$(OUT)/index.html \
		$(OUT)/web_client_bg.wasm \
		$(OUT)/web_client.js


.PHONY : help
help :
	@printf 'Makefile for https://github.com/donmccaughey/rust_wasm_web\n'
	@printf '\n'
	@printf 'Targets:\n'
	@printf '    all        Build everything (default target)\n'
	@printf '    run        Build everything and run the web client using\n'
	@printf "               Python's local web server\n"
	@printf '    clean      Remove all build output\n'
	@printf '\n'
	@printf 'Variables:\n'
	@printf '    OUT        Path for built web client (default is ./wwwroot)\n'
	@printf '    PORT       Network port for run target (default is 8000)\n'
	@printf '    TARGET     Path for cargo build products (default is ./tmp)\n'
	@printf '    TMP        Path for other build products (default is ./tmp)\n'
	@printf '\n'
	@printf 'Examples:\n'
	@printf '\n'
	@printf '    make TMP=build OUT=/usr/local/nignx/html/rust_wasm_web\n'
	@printf '\n'
	@printf '    make run PORT=1080\n'
	@printf '\n'


.PHONY : run
run : all
	cd $(OUT) && python -m SimpleHTTPServer $(PORT) 


.PHONY : clean
clean :
	cargo clean --target-dir $(TARGET)
	-rm -rf $(OUT)
	-rm -rf $(TMP)


$(OUT)/index.html : src/index.html | $(OUT)
	sed \
		-e s/{{datetime}}/$(datetime)/g \
		$< > $@

$(OUT)/web_client_bg.wasm : $(TMP)/web_client_bg.wasm | $(OUT)
	cp $< $@

$(OUT)/web_client.js : $(TMP)/web_client.js | $(OUT)
	cp $< $@

$(TMP)/web_client_bg.wasm \
$(TMP)/web_client.js : $(TMP)/wasm-bindgen.stamp.txt
	@:

$(TMP)/wasm-bindgen.stamp.txt : $(TARGET)/wasm32-unknown-unknown/debug/web_client.wasm | $(TMP)
	wasm-bindgen $< \
		--no-modules \
		--no-modules-global web_client \
		--no-typescript \
		--out-dir $(TMP)
	date > $@

-include $(TARGET)/wasm32-unknown-unknown/debug/web_client.d

$(TARGET)/wasm32-unknown-unknown/debug/web_client.wasm : Cargo.lock Cargo.toml
	cargo +nightly build \
		--target wasm32-unknown-unknown \
		--target-dir $(TARGET)

$(OUT) \
$(TMP):
	mkdir -p $@

