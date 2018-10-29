extern crate js_sys;
extern crate wasm_bindgen;
extern crate web_sys;

use web_sys::console;
use wasm_bindgen::prelude::*;
use wasm_bindgen::JsCast;


#[wasm_bindgen]
pub fn run(container_id: &str) -> Result<(), JsValue> {
    console::log_2(&"run() start, container_id:".into(), &container_id.into());

    let window = web_sys::window().expect("window not found");
    let document = window.document().expect("document not found");
    let container = document.get_element_by_id(container_id).expect("container not found");

    container.set_inner_html(r"
        <form id=form>
            <label for=name>Name:</label>
            <input name=name>
            <button>Say Hello</button>
        </form>
    ");

    let on_submit = Closure::wrap(Box::new(move |event: web_sys::Event| {
        event.prevent_default();
        let target = event.target().expect("target not found");
        let form = target.dyn_ref::<web_sys::HtmlFormElement>().expect("target should be an HtmlFormElement");
        let name_object = form.get_with_name("name");
        let name_input = name_object.dyn_ref::<web_sys::HtmlInputElement>().expect("name_object should be an HtmlInputElement");
        let value = name_input.value();
        let name = if 0 == value.len() { "no name" } else { &value };
        let message: String = format!("Hello, {}!", name);
        window.alert_with_message(&message).expect("alert failed");
        console::log_2(&"on_submit said hello to".into(), &name.into());
    }) as Box<Fn(_)>);

    let form = document.get_element_by_id("form").expect("form not found");
    let form = form.dyn_ref::<web_sys::HtmlElement>().expect("form should be an HtmlElement");
    (form.as_ref() as &web_sys::EventTarget)
        .add_event_listener_with_callback("submit", on_submit.as_ref().unchecked_ref())
        .expect("unable to add event listener");

    on_submit.forget();

    console::log_1(&"run() end".into());
    Ok(())
}

