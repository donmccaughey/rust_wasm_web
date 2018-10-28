OUT ?= $(abspath wwwroot)
TARGET ?= $(abspath tmp)
TMP ?= $(abspath tmp)


.PHONY : all
all : \
		$(OUT)/index.html \
		$(OUT)/web_client.js \
		$(OUT)/web_client_bg.wasm


.PHONY : clean
clean :
	cargo clean
	-rm -rf $(OUT)
	-rm -rf $(TMP)


$(OUT)/index.html : src/index.html | $(OUT)
	cp $< $@

$(OUT)/web_client.js \
$(OUT)/web_client_bg.wasm : $(TMP)/wasm-bindgen.stamp.txt
	@:

$(TMP)/wasm-bindgen.stamp.txt : $(TARGET)/wasm32-unknown-unknown/debug/web_client.wasm | $(OUT) $(TMP)
	wasm-bindgen $< \
		--no-modules \
		--no-modules-global web_client \
		--no-typescript \
		--out-dir $(OUT)
	date > $@

$(TARGET)/wasm32-unknown-unknown/debug/web_client.wasm : \
		Cargo.lock \
		Cargo.toml \
		src/lib.rs
	cargo +nightly build \
		--target wasm32-unknown-unknown \
		--target-dir $(TARGET)

$(OUT) \
$(TMP):
	mkdir -p $@

