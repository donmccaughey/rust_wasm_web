OUT ?= $(abspath wwwroot)
TARGET ?= $(abspath tmp)
TMP ?= $(abspath tmp)


.PHONY : all
all : \
		$(OUT)/index.html \
		$(OUT)/web_client_bg.wasm \
		$(OUT)/web_client.js


.PHONY : clean
clean :
	cargo clean
	-rm -rf $(OUT)
	-rm -rf $(TMP)


$(OUT)/index.html : src/index.html | $(OUT)
	cp $< $@

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

