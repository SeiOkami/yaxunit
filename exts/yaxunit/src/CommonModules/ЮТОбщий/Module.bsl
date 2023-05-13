//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2023 BIA-Technologies Limited Liability Company
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//©///////////////////////////////////////////////////////////////////////////©//

#Область СлужебныйПрограммныйИнтерфейс

#Область Строки

// ДобавитьСтроку
//  Конкатенирует строки, разделяя их разделителем
//
// Параметры:
//  ИсходнаяСтрока		 - Строка	 - Исходная строка
//  ДополнительнаяСтрока - Строка	 - Добавляемая строка
//  Разделитель			 - Строка	 - Строка разделитель, любой набор символов - разделитель между подстроками
// 
// Возвращаемое значение:
//  Строка - Результат конкатенации строк
//
Функция ДобавитьСтроку(Знач ИсходнаяСтрока, Знач ДополнительнаяСтрока, Знач Разделитель = ";") Экспорт
	
	Если Не ПустаяСтрока(ДополнительнаяСтрока) Тогда
		
		Если Не ПустаяСтрока(ИсходнаяСтрока) Тогда
			
			Возврат Строка(ИсходнаяСтрока) + Разделитель + Строка(ДополнительнаяСтрока);
			
		Иначе
			
			Возврат Строка(ДополнительнаяСтрока);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Строка(ИсходнаяСтрока);
	
КонецФункции

// РазложитьСтрокуВМассивПодстрок
// Возвращает массив на основании строки
//
// Параметры:
//  Значение - Строка - преобразуемая строка
//  Разделитель - Строка - строка-разделитель
//  УдалятьКонцевыеПробелы - Булево - удалять или нет концевые пробелы между элементами в строке
//  Фиксированный - Булево - возвращать фиксированный или обычный массив
// 
// Возвращаемое значение:
//  Массив Из Строка - массив строк
//
Функция РазложитьСтрокуВМассивПодстрок(Знач Значение, Разделитель = ";", УдалятьКонцевыеПробелы = Ложь) Экспорт
	
	КодУниверсальногоРазделителя = 5855;
	УниверсальныйРазделитель = Символ(КодУниверсальногоРазделителя);
	МодифицированнаяСтрока = СтрЗаменить(Значение, Разделитель, УниверсальныйРазделитель);
	
	МассивСтрок = ?(МодифицированнаяСтрока = "", Новый Массив, СтрРазделить(МодифицированнаяСтрока,
		УниверсальныйРазделитель));
	
	Если УдалятьКонцевыеПробелы Тогда
		
		Для Индекс = 0 По МассивСтрок.ВГраница() Цикл
			
			МассивСтрок[Индекс] = СокрЛП(МассивСтрок[Индекс]);
			
		КонецЦикла;
		
	КонецЕсли;
		
	Возврат МассивСтрок;
	
КонецФункции

// Сформировать строку символов.
//  Формирует строку из заданного количества повторяемых символов
// Параметры:
//  Символ - Строка - Повторяемый символ
//  Количество - Число - Количество повторений
// 
// Возвращаемое значение:
//  Строка - Строка повторяемых символов
Функция СформироватьСтрокуСимволов(Символ, Количество) Экспорт
	
	Возврат СтрСоединить(Новый Массив(Количество + 1), Символ);
	
КонецФункции

#КонецОбласти

#Область Числа

// Инкрементирует значение
// 
// Параметры:
//  Значение - Число
//  Шаг - Число
Процедура Инкремент(Значение, Знач Шаг = 1) Экспорт
	
	Значение = Значение + Шаг;
	
КонецПроцедуры

Функция ЧислоВСтроку(Значение) Экспорт
	
	Возврат Формат(Значение, "ЧН = 0; ЧГ=");
	
КонецФункции

#КонецОбласти

#Область ДатаВремя

// Человекочитаемое представление продолжительности
// 
// Параметры:
//  Продолжительность - Число - Продолжительность в миллисекундах
// 
// Возвращаемое значение:
//  Строка - Представление продолжительности
Функция ПредставлениеПродолжительности(Знач Продолжительность) Экспорт
	
	Представление = ЧислоВСтроку(Цел(Продолжительность / 1000));
	Представление = ДобавитьСтроку(Представление, Продолжительность % 1000, ".");
	
	Инкремент(Представление, " сек");
	
	Возврат Представление;
	
КонецФункции

Функция ПредставлениеУниверсальнойДата(Знач УниверсальнаяДатаВМиллисекундах = Неопределено) Экспорт
	
	Если УниверсальнаяДатаВМиллисекундах = Неопределено Тогда
		УниверсальнаяДатаВМиллисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КонецЕсли;
	
	Дата = '00010101' + УниверсальнаяДатаВМиллисекундах / 1000;
	Дата = МестноеВремя(Дата);
	
	Возврат СтрШаблон("%1.%2", Дата, Формат(УниверсальнаяДатаВМиллисекундах%1000, "ЧЦ=3; ЧН=000; ЧВН=; ЧГ=0;"));
	
КонецФункции

#КонецОбласти

#Область Коллекции

// ЗначениеСтруктуры
// Возвращает требуемое поле структуры. В случае отсутствия поля возвращает значение по умолчанию
// 
// Параметры:
//  ИсходнаяСтруктура - Структура - Исходная структура
//  ИмяПоля - Строка - Имя поля структуры
//  ЗначениеПоУмолчанию - Произвольный - Значение, которое будет возвращено, если поля в структуре нет
//  ПроверятьЗаполненность - Булево - Необходимость проверять значение на заполненность. Если не заполнено,
// то возвращается значение по умолчанию
// 
// Возвращаемое значение:
//  Произвольный - Значение искомого поля структуры
Функция ЗначениеСтруктуры(Знач ИсходнаяСтруктура, ИмяПоля, Знач ЗначениеПоУмолчанию = Неопределено,	ПроверятьЗаполненность = Ложь) Экспорт
	
	Если ПустаяСтрока(ИмяПоля) Тогда
		
		Возврат ЗначениеПоУмолчанию;
		
	КонецЕсли;
	
	ЗначениеПоля = Неопределено;
	Если ИсходнаяСтруктура.Свойство(ИмяПоля, ЗначениеПоля) Тогда
		Если ПроверятьЗаполненность И ЗначениеЗаполнено(ЗначениеПоля) Или Не ПроверятьЗаполненность Тогда
			Возврат ЗначениеПоля;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ЗначениеПоУмолчанию;
	
КонецФункции

// ОбъединитьВСтруктуру
//  Функция, объединяющая две коллекции( с типами Структура или Соответствие) в одну структуру, если это возможно
//
// Параметры:
//  Коллекция1 - Соответствие из Произвольный
//             - Структура
//  Коллекция2 - Соответствие из Произвольный
//             - Структура
// 
// Возвращаемое значение:
//  Структура - Результат объединения двух коллекций
//
Функция ОбъединитьВСтруктуру(Знач Коллекция1, Коллекция2) Экспорт
	
	Если ТипЗнч(Коллекция1) <> Тип("Структура") Тогда
		Коллекция1 = СкопироватьСтруктуру(Коллекция1);
	КонецЕсли;
	
	Возврат ДобавитьКлючИЗначениеВКоллекцию(Коллекция1, Коллекция2);
	
КонецФункции

// СкопироватьРекурсивно
//  Создает копию экземпляра указанного объекта.
//  Примечание:
//  Функцию нельзя использовать для объектных типов (СправочникОбъект, ДокументОбъект и т.п.).
//
// Параметры:
//  Источник - Произвольный	 - объект, который необходимо скопировать.
// 
// Возвращаемое значение:
//  Произвольный - копия объекта, переданного в параметре Источник.
//
Функция СкопироватьРекурсивно(Знач Источник) Экспорт
	
	Перем Приемник;
	
	СкопироватьПрисвоением = Ложь;
	
	ТипИсточника = ТипЗнч(Источник);
	Если ТипИсточника = Тип("Структура") Или ТипИсточника = Тип("ФиксированнаяСтруктура") Тогда
		
		Приемник = СкопироватьСтруктуру(Источник);
		
	ИначеЕсли ТипИсточника = Тип("Соответствие") Или ТипИсточника = Тип("ФиксированноеСоответствие") Тогда
		
		Приемник = СкопироватьСоответствие(Источник);
		
	ИначеЕсли ТипИсточника = Тип("Массив") Или ТипИсточника = Тип("ФиксированныйМассив") Тогда
		
		Приемник = СкопироватьМассив(Источник);
		
	ИначеЕсли ТипИсточника = Тип("СписокЗначений") Тогда
		
		Приемник = СкопироватьСписокЗначений(Источник);
		
	Иначе
		
		СкопироватьПрисвоением = Истина;
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Если ТипИсточника = Тип("ТаблицаЗначений") Или ТипИсточника = Тип("ДеревоЗначений") Тогда
			
			СкопироватьПрисвоением = Ложь;
			Приемник = Источник.Скопировать();
			
		КонецЕсли;
#КонецЕсли
		
	КонецЕсли;
	
	Если СкопироватьПрисвоением Тогда
	
		Приемник = Источник;
	
	КонецЕсли;
	
	Возврат Приемник;
	
КонецФункции

// СкопироватьСтруктуру
//  Создает копию значения типа Структура
//
// Параметры:
//  СтруктураИсточник - Структура - копируемая структура
// 
// Возвращаемое значение:
//  Структура - копия исходной структуры.
//
Функция СкопироватьСтруктуру(СтруктураИсточник) Экспорт
	
	СтруктураРезультат = Новый Структура;
	
	Для Каждого КлючИЗначение Из СтруктураИсточник Цикл
		СтруктураРезультат.Вставить(КлючИЗначение.Ключ, СкопироватьРекурсивно(КлючИЗначение.Значение));
	КонецЦикла;
	
	Возврат СтруктураРезультат;
	
КонецФункции

// СкопироватьСоответствие
//  Создает копию значения типа Соответствие.
//
// Параметры:
//  СоответствиеИсточник - Соответствие из Произвольный - соответствие, копию которого необходимо получить.
// 
// Возвращаемое значение:
//  Соответствие Из Произвольный - копия исходного соответствия.
//
Функция СкопироватьСоответствие(СоответствиеИсточник) Экспорт
	
	СоответствиеРезультат = Новый Соответствие;
	
	Для Каждого КлючИЗначение Из СоответствиеИсточник Цикл
		
		СоответствиеРезультат.Вставить(СкопироватьРекурсивно(КлючИЗначение.Ключ),
									   СкопироватьРекурсивно(КлючИЗначение.Значение));
		
	КонецЦикла;
	
	Возврат СоответствиеРезультат;
	
КонецФункции

// СкопироватьМассив
//  Создает копию значения типа Массив.
//
// Параметры:
//  МассивИсточник - Массив Из Произвольный - массив, копию которого необходимо получить
// 
// Возвращаемое значение:
//  Массив Из Произвольный - копия исходного массива.
//
Функция СкопироватьМассив(МассивИсточник) Экспорт
	
	МассивРезультат = Новый Массив;
	
	Для Каждого Элемент Из МассивИсточник Цикл
		
		МассивРезультат.Добавить(СкопироватьРекурсивно(Элемент));
		
	КонецЦикла;
	
	Возврат МассивРезультат;
	
КонецФункции

// СкопироватьСписокЗначений
//  Создает копию значения типа СписокЗначений.
//
// Параметры:
//  СписокИсточник - СписокЗначений Из Произвольный - список значений, копию которого необходимо получить
// 
// Возвращаемое значение:
//  СписокЗначений Из Произвольный - копия исходного списка значений
//
Функция СкопироватьСписокЗначений(СписокИсточник) Экспорт
	
	СписокРезультат = Новый СписокЗначений;
	
	Для Каждого ЭлементСписка Из СписокИсточник Цикл
		
		СписокРезультат.Добавить(СкопироватьРекурсивно(ЭлементСписка.Значение),
								 ЭлементСписка.Представление,
								 ЭлементСписка.Пометка,
								 ЭлементСписка.Картинка);
		
	КонецЦикла;
	
	Возврат СписокРезультат;
	
КонецФункции

Функция ВыгрузитьЗначения(Знач Коллекция, Знач ИмяРеквизита) Экспорт
	
	Результат = Новый Массив();
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		
		Результат.Добавить(ЭлементКоллекции[ИмяРеквизита]);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПересечениеМассивов(Коллекция1, Коллекция2) Экспорт
	
	Результат = Новый Массив;
	
	Для Каждого Элемент Из Коллекция1 Цикл
		
		Если Коллекция2.Найти(Элемент) <> Неопределено Тогда
			Результат.Добавить(Элемент);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ЗначениеВМассиве(Значение,
							Значение2 = "_!%*",
							Значение3 = "_!%*",
							Значение4 = "_!%*",
							Значение5 = "_!%*",
							Значение6 = "_!%*",
							Значение7 = "_!%*",
							Значение8 = "_!%*",
							Значение9 = "_!%*",
							Значение10 = "_!%*") Экспорт
	
	Массив = Новый Массив;
	Массив.Добавить(Значение);
	
	ФлагОкончания = "_!%*";
	
	Значения = Новый Массив;
	
	Если Значение <> ФлагОкончания Тогда
		Значения.Добавить(Значение);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение2 <> ФлагОкончания Тогда
		Значения.Добавить(Значение2);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение3 <> ФлагОкончания Тогда
		Значения.Добавить(Значение3);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение4 <> ФлагОкончания Тогда
		Значения.Добавить(Значение4);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение5 <> ФлагОкончания Тогда
		Значения.Добавить(Значение5);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение6 <> ФлагОкончания Тогда
		Значения.Добавить(Значение6);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение7 <> ФлагОкончания Тогда
		Значения.Добавить(Значение7);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение8 <> ФлагОкончания Тогда
		Значения.Добавить(Значение8);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение9 <> ФлагОкончания Тогда
		Значения.Добавить(Значение9);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Если Значение10 <> ФлагОкончания Тогда
		Значения.Добавить(Значение10);
	Иначе
		Возврат Значения;
	КонецЕсли;
	
	Возврат Значения;
	
КонецФункции

Процедура ДополнитьМассив(Приемник, Источник) Экспорт
	
	Для Каждого Элемент Из Источник Цикл
		
		Приемник.Добавить(Элемент);
		
	КонецЦикла;
	
КонецПроцедуры

// 	Возвращает соответствие элементов переданной коллекции, в качестве ключей выступают значения указанного поля элементов коллекции.
// 
// Параметры:
// 	Коллекция - Произвольный - значение, для которого определен итератор, и возможно обращение к полям элементов через квадратные скобки.
// 	ИмяПоляКлюча - Строка - имя поля элемента коллекции, которое будет ключом соответствия.
// 	ИмяПоляЗначения - Строка - если указан, значениями результата будут не элементы, а значения соответствующих полей элементов коллекции.
// Возвращаемое значение:
// 	Соответствие Из Произвольный - полученное соответствие.
Функция ВСоответствие(Коллекция, ИмяПоляКлюча, ИмяПоляЗначения = Неопределено) Экспорт
	
	Результат = Новый Соответствие();
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		
		Значение = ?(ИмяПоляЗначения = Неопределено, ЭлементКоллекции, ЭлементКоллекции[ИмяПоляЗначения]);
		
		Результат.Вставить(ЭлементКоллекции[ИмяПоляКлюча], Значение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает структуру элементов переданной коллекции, в качестве ключей выступают значения указанного поля элементов коллекции.
// 
// Параметры:
// 	Коллекция - Произвольный - значение, для которого определен итератор, и возможно обращение к полям элементов через квадратные скобки.
// 	ИмяПоляКлюча - Строка - имя поля элемента коллекции, которое будет ключом соответствия.
// 	ИмяПоляЗначения - Строка - если указан, значениями результата будут не элементы, а значения соответствующих полей элементов коллекции.
// Возвращаемое значение:
// 	Структура Из Произвольный - полученная структура.
Функция ВСтруктуру(Коллекция, ИмяПоляКлюча, ИмяПоляЗначения = Неопределено) Экспорт
	
	Результат = Новый Структура();
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		
		Значение = ?(ИмяПоляЗначения = Неопределено, ЭлементКоллекции, ЭлементКоллекции[ИмяПоляЗначения]);
		
		Результат.Вставить(ЭлементКоллекции[ИмяПоляКлюча], Значение);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// см. ЮТСравнениеКлиентСервер.ЗначенияРавны
// Deprecate
Функция ДанныеСовпадают(Данные1, Данные2) Экспорт
	
	ВызовУстаревшегоМетода("ЮТОбщий.ДанныеСовпадают", "ЮТСравнениеКлиентСервер.ЗначенияРавны");
	Возврат ЮТСравнениеКлиентСервер.ЗначенияРавны(Данные1, Данные2);
	
КонецФункции

#КонецОбласти

#Область ЧтениеДанных

Функция ДанныеТекстовогоФайла(ИмяФайла) Экспорт
	
#Если НЕ ВебКлиент Тогда
	Чтение = Новый ЧтениеТекста;
	Чтение.Открыть(ИмяФайла, "UTF-8");
	Текст = Чтение.Прочитать();
	Чтение.Закрыть();
	
	Возврат Текст;
#Иначе
	ВызватьИсключение "Чтение данных текстовых файлов в веб-клиенте не поддерживается";
#КонецЕсли
	
КонецФункции

Функция ЗначениеИзJSON(СтрокаJSON) Экспорт
	
#Если НЕ ВебКлиент Тогда
	Чтение = Новый ЧтениеJSON;
	Чтение.УстановитьСтроку(СтрокаJSON);
	Значение = ПрочитатьJSON(Чтение);
	Чтение.Закрыть();
	Возврат Значение;
#Иначе
	ВызватьИсключение "Разбор JSON строки в веб-клиенте не поддерживается";
#КонецЕсли
	
КонецФункции

#КонецОбласти

// МетодМодуляСуществует
// Проверяет существование публичного (экспортного) метода у объекта
// 
// Параметры:
//  ИмяМодуля - Строка - Имя модуля, метод которого нужно поискать
//  ИмяМетода - Строка - Имя метода, который ищем
//  КоличествоПараметров - Число - Количество параметров метода, увы это никак не влияет на проверку
//  Кешировать - Булево - Признак кеширования результата проверки
// 
// Возвращаемое значение:
//  Булево - Метод найден
Функция МетодМодуляСуществует(ИмяМодуля, ИмяМетода, КоличествоПараметров = 0, Кешировать = Истина) Экспорт
	
	Если Кешировать Тогда
		Возврат ЮТПовторногоИспользования.МетодМодуляСуществует(ИмяМодуля, ИмяМетода, КоличествоПараметров);
	КонецЕсли;
	
	Алгоритм = СтрШаблон("%1.%2(,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,)", ИмяМодуля, ИмяМетода);
	
	Ошибка = ВыполнитьМетод(Алгоритм);
	МетодСуществует = СтрНайти(НРег(Ошибка.Описание), "(" + НРег(ИмяМетода) + ")") = 0;
	
	Возврат МетодСуществует;
	
КонецФункции

Функция ВыполнитьМетод(ПолноеИмяМетода, Параметры = Неопределено) Экспорт
	
#Если ВебКлиент Тогда
	ВызватьИсключение МетодНеДоступен("ЮТОбщий.ВыполнитьМетод");
#Иначе
	Если СтрЗаканчиваетсяНа(ПолноеИмяМетода, ")") Тогда
		
		Алгоритм = ПолноеИмяМетода;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(Параметры) Тогда
		
		Алгоритм = ПолноеИмяМетода + "()";
		
	Иначе
		
		Алгоритм = "";
		Для Инд = 0 По Параметры.ВГраница() Цикл
			
			Алгоритм = ДобавитьСтроку(Алгоритм, СтрШаблон("Параметры[%1]", Инд), ", ");
			
		КонецЦикла;
		
		Алгоритм = СтрШаблон("%1(%2)", ПолноеИмяМетода, Алгоритм);
		
	КонецЕсли;
	
	Попытка
		//@skip-check server-execution-safe-mode
		Выполнить(Алгоритм);
	Исключение
		Возврат ИнформацияОбОшибке();
	КонецПопытки;
	
	Возврат Неопределено;
#КонецЕсли
	
КонецФункции

// ПеременнаяСодержитСвойство
//  функция проверяет наличие свойства у значения любого типа данных. Если передано НЕОПРЕДЕЛЕНО, то ф-ия всегда вернет Ложь
//
// Параметры:
//  Переменная	 - Произвольный	 - переменная любого типа, для которой необходимо проверить наличие свойства
//  ИмяСвойства	 - Строка		 - переменная типа "Строка", содержащая искомое свойства
// 
// Возвращаемое значение:
//  Булево - признак наличия свойства у значения
//
Функция ПеременнаяСодержитСвойство(Переменная, ИмяСвойства) Экспорт
	
	Если Переменная = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Инициализируем структуру для теста с ключом (значение переменной "ИмяСвойства") и значением произвольного GUID'а
	GUIDПроверка = Новый УникальныйИдентификатор;
	СтруктураПроверка = Новый Структура;
	СтруктураПроверка.Вставить(ИмяСвойства, GUIDПроверка);
	// Заполняем созданную структуру из переданного значения переменной
	ЗаполнитьЗначенияСвойств(СтруктураПроверка, Переменная);
	// Если значение для свойства структуры осталось GUIDПроверка, то искомое свойство не найдено, и наоборот.
	Возврат СтруктураПроверка[ИмяСвойства] <> GUIDПроверка;
	
КонецФункции

// СообщитьПользователю
//  Формирует и выводит сообщение
//
// Параметры:
//  ТекстСообщенияПользователю	 - Строка	 - текст сообщения.
Процедура СообщитьПользователю(ТекстСообщенияПользователю) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = СокрЛП(ТекстСообщенияПользователю);
	Сообщение.Сообщить();
	
КонецПроцедуры

Функция СтрокаJSON(Значение) Экспорт
	
#Если ВебКлиент Тогда
	ВызватьИсключение МетодНеДоступен("ЮТОбщий.СтрокаJSON");
#Иначе
	ЗаписьJSON = Новый ЗаписьJSON();
	ЗаписьJSON.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, Значение);
	
	Возврат ЗаписьJSON.Закрыть();
#КонецЕсли

КонецФункции // СтрокаJSON

Функция ПредставлениеЗначения(Значение) Экспорт
	
	Попытка
		Возврат СтрокаJSON(Значение);
	Исключение
		Возврат Строка(Значение);
	КонецПопытки;
	
КонецФункции

Функция ПредставлениеТипа(Тип) Экспорт
	
#Если ВебКлиент Тогда
	ВызватьИсключение МетодНеДоступен("ЮТОбщий.ПредставлениеТипа");
#Иначе
	ТипXML = СериализаторXDTO.XMLТип(Тип);
	
	Если ТипXML = Неопределено Тогда
		Возврат Строка(Тип);
	Иначе
		Возврат ТипXML.ИмяТипа;
	КонецЕсли;
#КонецЕсли
	
КонецФункции

Функция МетодНеДоступен(ИмяМетода, ИмяКонтекста = "веб-клиенте") Экспорт
	
	Возврат СтрШаблон("Метод `%1` не доступен в %2");
	
КонецФункции

Функция ВычислитьБезопасно(Выражение) Экспорт
	
#Если НЕ ВебКлиент И НЕ ТонкийКлиент Тогда
	УстановитьБезопасныйРежим(Истина);
	Попытка
		Значение = Вычислить(Выражение);
	Исключение
		УстановитьБезопасныйРежим(Ложь);
		ВызватьИсключение;
	КонецПопытки;
	
	УстановитьБезопасныйРежим(Ложь);
#Иначе
	Значение = Вычислить(Выражение);
#КонецЕсли
	
	Возврат Значение;
	
КонецФункции

// Параметры записи объекта
// 
// Возвращаемое значение:
//  Структура - Параметры записи:
// * ОбменДаннымиЗагрузка - Булево
// * ДополнительныеСвойства - Структура
// * РежимЗаписи - РежимЗаписиДокумента
Функция ПараметрыЗаписи() Экспорт
	
	ПараметрыЗаписи = Новый Структура();
	ПараметрыЗаписи.Вставить("ОбменДаннымиЗагрузка", Ложь);
	ПараметрыЗаписи.Вставить("ДополнительныеСвойства", Новый Структура);
	ПараметрыЗаписи.Вставить("РежимЗаписи", РежимЗаписиДокумента.Запись);
	
	Возврат ПараметрыЗаписи;
	
КонецФункции

// Описание типов любая ссылка.
// 
// Возвращаемое значение:
//  ОписаниеТипов - Описание типов любая ссылка
Функция ОписаниеТиповЛюбаяСсылка() Экспорт
	
	Возврат ЮТПовторногоИспользования.ОписаниеТиповЛюбаяСсылка();
	
КонецФункции

Процедура ВызовУстаревшегоМетода(УстаревшийМетод, РекомендуемыйМетод = Неопределено) Экспорт
	
	Сообщение = СтрШаблон("Используется устаревший метод '%1'. В следующий релизах метод будет удален", УстаревшийМетод);
	
	Если ЗначениеЗаполнено(РекомендуемыйМетод) Тогда
		Сообщение = СтрШаблон("%1. Рекомендуется использовать '%2'", Сообщение, РекомендуемыйМетод);
	КонецЕсли;
	
	СообщитьПользователю(Сообщение);
	
КонецПроцедуры

Функция НеподдерживаемыйПараметрМетода(ИмяМетода, ЗначениеПараметра) Экспорт
	
	Возврат СтрШаблон("Неподдерживаемый параметры метода `%1` `%2`(%3)", ИмяМетода, ЗначениеПараметра, ТипЗнч(ЗначениеПараметра));
	
КонецФункции

Функция УстановленБезопасныйРежим() Экспорт
	
	Возврат ЮТОбщийВызовСервера.УстановленБезопасныйРежим();
	
КонецФункции

Функция МестноеВремяПоВременнойМетке(Метка) Экспорт
	
	Если ЗначениеЗаполнено(Метка) Тогда
		Возврат МестноеВремя('00010101' + Метка / 1000);
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ПродолжительностьВСекундах(Продолжительность) Экспорт
	
	Возврат Продолжительность / 1000;
	
КонецФункции

Функция Модуль(ИмяМодуля) Экспорт
	
	Возврат ВычислитьБезопасно(ИмяМодуля);
	
КонецФункции

Функция Менеджер(Знач Менеджер) Экспорт
	
	Возврат ЮТОбщийВызовСервера.Менеджер(Менеджер);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКлючИЗначениеВКоллекцию(КоллекцияРезультат, Коллекция)
	
	Для Каждого Элемент Из Коллекция Цикл
		
		КоллекцияРезультат.Вставить(Элемент.Ключ, Элемент.Значение);
		
	КонецЦикла;
	
	Возврат КоллекцияРезультат;
	
КонецФункции

Функция ПредставлениеОбъекта(Объект, Знач Уровень = 1, ПредставлениеОбъекта = Неопределено)
	
	ТипОбъекта = ТипЗнч(Объект);
	
	Шаблон = "%1 (%2)";
	Представление = "";
	ПредставлениеТипа = ТипОбъекта;
	
	Если ТипОбъекта = Тип("Структура") ИЛИ ТипОбъекта = Тип("Соответствие") Тогда
		СформироватьСтрокуСимволов(" ", Уровень * 4);
		Шаблон = "%2:
				 |%1";
		Представление = СформироватьСтрокуСимволов(" ", Уровень * 4) + ПредставлениеСтруктуры(Объект, Уровень);
		
	ИначеЕсли ТипОбъекта = Тип("Массив") Тогда
		
		Шаблон = "[%1] (%2)";
		Представление = СтрСоединить(Объект, ", ");
		
	ИначеЕсли ТипОбъекта = Тип("Число") Тогда
		
		Представление = ЧислоВСтроку(Объект);
		
	ИначеЕсли ТипОбъекта = Тип("Дата") Тогда
		
		Представление = Формат(Объект, "ДФ=""dd.MM.yyyy ЧЧ:мм:сс""");
		
	ИначеЕсли ТипОбъекта = Тип("Булево") Тогда
		
		Представление = Строка(Объект);
		
	ИначеЕсли ТипОбъекта = Тип("Строка") Тогда
		
		Представление = Объект;
		
	Иначе
		
		Представление = Строка(Объект);
		ПредставлениеТипа = ПредставлениеТипа(ТипОбъекта); // Для ссылочных
		
	КонецЕсли;
	
	Если ПустаяСтрока(Представление) Тогда
		
		Представление = "<Пусто>";
		
	КонецЕсли;
	
	Возврат СтрШаблон(Шаблон, Представление, ?(ПредставлениеОбъекта = Неопределено, ПредставлениеТипа, ПредставлениеОбъекта));
	
КонецФункции

Функция ПредставлениеСтруктуры(Значение, Уровень)
	
	Строки = Новый Массив();
	
	Для Каждого Элемент Из Значение Цикл
		
		Строки.Добавить(СтрШаблон("%1: %2", Элемент.Ключ, ПредставлениеОбъекта(Элемент.Значение, Уровень + 1)));
		
	КонецЦикла;
	
	Возврат СтрСоединить(Строки, Символы.ПС + СформироватьСтрокуСимволов(" ", Уровень * 4));
	
КонецФункции

#КонецОбласти
