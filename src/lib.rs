extern crate wasm_bindgen;
extern crate web_sys;

use web_sys::console;
use wasm_bindgen::prelude::*;


#[wasm_bindgen]
pub fn run(container_id: &str) -> Result<(), JsValue> {
    console::log_2(&"run() start, container_id:".into(), &container_id.into());

    let window = web_sys::window().expect("window not found");
    window.alert_with_message(&format!("Hello, rust_wasm_web!"))?;

    let document = window.document().expect("document not found");
    let container = document.get_element_by_id(container_id).expect("container not found");

    container.set_inner_html("<p>Hello, <code>rust_wasm_web</code>!</p>");

    console::log_1(&"run() end".into());
    Ok(())
}

