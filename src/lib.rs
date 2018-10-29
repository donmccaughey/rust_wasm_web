extern crate js_sys;
extern crate wasm_bindgen;
extern crate web_sys;

use wasm_bindgen::prelude::*;
use wasm_bindgen::JsCast;
use web_sys::console;
use web_sys::Event;
use web_sys::EventTarget;
use web_sys::HtmlFormElement;
use web_sys::HtmlInputElement;


#[wasm_bindgen]
pub fn run(container_id: &str) -> Result<(), JsValue> {
    console::log_2(&"run() start, container_id:".into(), &container_id.into());

    let window = web_sys::window()
            .ok_or_else(|| JsValue::from_str("window() failed"))?;
    let document = window.document()
            .ok_or_else(|| JsValue::from_str("document not found"))?;
    let container = document.get_element_by_id(container_id)
            .ok_or_else(|| JsValue::from_str("container not found"))?;

    container.set_inner_html(r"
        <form id=form>
            <label for=name>Name:</label>
            <input name=name>
            <button>Say Hello</button>
        </form>
    ");

    let on_submit = Closure::wrap(Box::new(move |event: Event| -> Result<(), JsValue> {
        event.prevent_default();
        let target = event.target()
                .ok_or_else(|| JsValue::from_str("target not found"))?;
        let form: &HtmlFormElement = target.dyn_ref()
                .ok_or_else(|| JsValue::from_str("target should be an HtmlFormElement"))?;
        let name_object = form.get_with_name("name");
        let name_input: &HtmlInputElement = name_object.dyn_ref()
                .ok_or_else(|| JsValue::from_str("name should be an HtmlInputElement"))?;
        let value = name_input.value();
        let name = if 0 == value.len() { "no name" } else { &value };
        let message = format!("Hello, {}!", name);
        window.alert_with_message(&message)?;
        console::log_2(&"on_submit said hello to".into(), &name.into());
        Ok(())
    }) as Box<Fn(_) -> _>);

    let form = document.get_element_by_id("form")
            .ok_or_else(|| JsValue::from_str("form not found"))?;
    (form.as_ref() as &EventTarget)
            .add_event_listener_with_callback("submit", on_submit.as_ref().unchecked_ref())?;

    on_submit.forget();

    console::log_1(&"run() end".into());
    Ok(())
}

