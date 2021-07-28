# Программа чтения XML визиток.

# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX

require 'rexml/document'

#current_path = File.dirname(__FILE__)
file_name = "C:/RubyTut2/lesson8/card_reader/my_card.xml"

abort "Извиняемся, хозяин, файлик my_card.xml не найден." unless File.exist?(file_name)

# Читаем файл в формате UTF-8
file = File.new(file_name, 'r:UTF-8')

# Создадим пустой Хэш
card = {}

# Создадим из файла REXML-объект
doc = REXML::Document.new(file)


['person', 'number', 'email', 'skills', 'photo'].each do |field|
  card[field] = doc.root.elements[field].text
  # Наполнение хэша "полями" из хмл, /text выводит текст между тегов
  #Если не поставить 'r:UTF-8', то не работает метод .text
end


file.close

puts 'Данные *.xml прочитаны.'

#Теперь обратимся к HTML документу
# Путь:
html_file_name = File.dirname(__FILE__) + "/1.html"

#Доступ к файлу для записи:
html_file = File.new(html_file_name, "w:UTF-8")
abort "Извиняемся, хозяин, файлик 1.html не найден." unless File.exist?(html_file_name)

#Наполним документ тегами HTML:
html_file.puts '<!DOCTYPE HTML>'

#Создадим из файла REXML-объект:
html = REXML::Document.new
html.add_element 'HTML', {'lang' => 'ru'}

html.root.add_element 'meta', {'charset' => 'UTF-8'}
html.root.add_element('title').add_text 'Визитка'

body = html.root.add_element('body')

# Вставим фото
# Ширину и высоту картинки уменьшим, добави хеш-тег для изображения.

body.add_element('p').add_element('img', {'src' => card['photo'],
                                          'width' => "189",
                                          'height' => "255",
                                          'title' => "Stanislav A. Timanov"
})

#Далее наполним тело вэб-страницы полями из хэша "кард"

body.add_element('p').add_text("#{card['person']}")
body.add_element('p').add_text("#{card['number']}")
body.add_element('p').add_text("#{card['email']}")
body.add_element('p').add_text("#{card['skills']}")

# Запишем в файл значения, с интервалами в 2 пробела

html.write(html_file, 2)
html_file.close



