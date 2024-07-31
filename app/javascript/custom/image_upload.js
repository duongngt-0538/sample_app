import { I18n } from "i18n-js";

async function loadTranslations() {
  const response = await fetch("/locales/translations.json");
  if (!response.ok) {
    console.error("Failed to load translations:", response.statusText);
    return;
  }

  const translations = await response.json();
  const i18n = new I18n(translations);
  const currentLocale = document.documentElement.lang || "en";
  i18n.locale = currentLocale;

  document.addEventListener("turbo:load", function() {
    document.addEventListener("change", function(event) {
      let image_upload = document.querySelector('#micropost_image');
      if (image_upload.files && image_upload.files.length > 0) {
        const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;
        if (size_in_megabytes > 5) {
          alert(i18n.t("shared.micropost_form.max_size"));
          image_upload.value = "";
        }
      }
    });
  });
}

loadTranslations();
