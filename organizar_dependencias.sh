#!/bin/bash

# Archivo de entrada y salida
input_file="indice_completo.txt"
output_file="indice_organizado.txt"

# Limpia el archivo de salida antes de comenzar
> "$output_file"

# Función para escribir encabezados de módulos
write_module_header() {
    echo -e "\n## Módulo: $1\n" >> "$output_file"
}

# Función para escribir dependencias en bloques específicos
write_dependency() {
    echo "- $1" >> "$output_file"
}

# Organiza las dependencias en módulos y bloques
while IFS= read -r line; do
    case "$line" in
        *appcompat*) write_module_header "Interfaz de Usuario y Componentes Visuales"
                     write_dependency "$line" ;;
        *okhttp*|*retrofit*|*gson*) write_module_header "Comunicación y Red"
                                     write_dependency "$line" ;;
        *tensorflow*|*mlkit*) write_module_header "IA y Machine Learning"
                              write_dependency "$line" ;;
        *firebase-auth*|*security-crypto*|*conscrypt*) write_module_header "Autenticación y Seguridad"
                                                      write_dependency "$line" ;;
        *room*|*firestore*|*datastore*) write_module_header "Persistencia y Almacenamiento"
                                        write_dependency "$line" ;;
        *firebase-messaging*|*firebase-analytics*) write_module_header "Notificaciones y Mensajería"
                                                   write_dependency "$line" ;;
        *lifecycle*|*navigation*) write_module_header "Navegación y Ciclo de Vida"
                                  write_dependency "$line" ;;
        *timber*|*coil*|*glide*) write_module_header "Utilidades"
                                 write_dependency "$line" ;;
        *play-services*) write_module_header "Servicios de Google"
                        write_dependency "$line" ;;
        *) write_module_header "Otros"
           write_dependency "$line" ;;
    esac
done < "$input_file"

echo "Dependencias organizadas en $output_file"
