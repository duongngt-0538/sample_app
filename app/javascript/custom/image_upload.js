import { I18n } from "i18n-js";
import translations from "/locales/translations.json";

const i18n = new I18n(translations);

document.addEventListener("turbo:load", function() {
  document.addEventListener("change", function(event) {
    let image_upload = document.querySelector('#micropost_image');
    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;
    if (size_in_megabytes > 5) {
      alert(i18n.t("shared.micropost_form.max_size"));
      image_upload.value = "";
    }
  });
});
