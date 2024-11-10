 Directorio donde están ubicados los archivos resultado_tequis.txt
input_directory="/ruta/al/directorio/de/tequis"
output_file="organized_index.txt"

# Buscar archivos resultado_tequis*.txt y aplicar permisos si es necesario
find "$input_directory" -name "resultado_tequis*.txt" -exec chmod +r {} \;

# Limpiar el archivo de salida si ya existe
> "$output_file"

# Función para escribir encabezados de módulos y bloques en el archivo de salida
write_header() {
    echo -e "\n## $1\n" >> "$output_file"
}

# Procesa cada archivo resultado_tequis*.txt en el directorio de entrada
for file in "$input_directory"/resultado_tequis*.txt; do
    # Agrega al archivo de salida el nombre del archivo que se está procesando
    echo "Procesando archivo: $file" >> "$output_file"
    echo "-------------------------------------" >> "$output_file"
    
    # Variables para el seguimiento de módulos y bloques
    current_module=""
    current_block=""

    # Lee cada línea del archivo
    while IFS= read -r line; do
        # Detecta el inicio de un nuevo módulo (ajusta el patrón según el formato)
        if [[ "$line" =~ "Módulo:" ]]; then
            current_module=$(echo "$line" | sed 's/Módulo: //')
            write_header "Módulo: $current_module"
        
        # Detecta el inicio de un nuevo bloque dentro de un módulo
        elif [[ "$line" =~ "Bloque:" ]]; then
            current_block=$(echo "$line" | sed 's/Bloque: //')
            write_header "Bloque: $current_block"
        
        # Detecta dependencias y las organiza bajo el módulo y bloque actual
        elif [[ "$line" =~ "Dependencia:" ]]; then
            dependency=$(echo "$line" | sed 's/Dependencia: //')
            echo "- $dependency" >> "$output_file"
        
        # Organiza funciones específicas si están indicadas
        elif [[ "$line" =~ "Función:" ]]; then
            function_desc=$(echo "$line" | sed 's/Función: //')
            echo "  * Función: $function_desc" >> "$output_file"
        
        # Agrega otros detalles de archivos o ubicaciones como sub-puntos
        elif [[ "$line" =~ "Archivo:" || "$line" =~ "Ubicación:" ]]; then
            echo "  - $line" >> "$output_file"
        
        fi
    done < "$file"
    
    # Línea en blanco para separar el contenido de cada archivo
    echo "" >> "$output_file"
done

# Mensaje de confirmación al finalizar
echo "Las dependencias han sido organizadas en $output_file"

# Otorga permisos de lectura y escritura al archivo de salida
chmod +rw "$output_file"
