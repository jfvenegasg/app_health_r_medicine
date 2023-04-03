library(chatgpt)
# install.packages("pak")
# pak::pak("MichelNivard/gptstudio")
Sys.setenv(OPENAI_API_KEY = "")

cat(chatgpt::ask_chatgpt(question = "que es una manzana"))



library(httr)

# Define las credenciales de tu cuenta de WriteSonic
email <- "j.venegasgutierrez@gmail.com"
password <- "eca3c81a-b179-4e46-88aa-f966298e1347"

library(httr)

# Definir los parámetros necesarios para la solicitud
params <- list(
  "api_key" = "eca3c81a-b179-4e46-88aa-f966298e1347",
  "text" = "que es una manzana",
  "model" = "standard",
  "num_results" = 1
)

# Hacer la solicitud a la API de WriteSonic
response <- POST("https://api.writesonic.com/v1/writesonic",
                 body = params, encode = "form")

# Obtener el resultado de la solicitud
result <- content(response, as = "parsed")

# Imprimir el resultado
print(result)
