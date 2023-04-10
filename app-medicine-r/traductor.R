#si quieres traducir mas palabras,solo debes agregar la funcion i18n$t() a cada texto y luego agregar la 
#traduccion al archivo translation_en.csv que esta en la carpeta data

# diccionario
i18n <- Translator$new(translation_json_path = "modulos/data/translation_en.json")

# si quieres cambiar a español,solo cambiar en por es y viceversa
i18n$set_translation_language("es")
