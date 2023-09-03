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

// МодулиРасширений
// Выполняет чтение метаданных общих модулей, которые предположительно могут являться тестами
// 
// Возвращаемое значение:
//  Массив из см. ЮТФабрика.ОписаниеМодуля - Коллекция описаний моделей, структуру элемента см. ЮТФабрика.ОписаниеМодуля
Функция МодулиРасширений() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МетаданныеМодулей = Новый Массив;
	
	Для Каждого Модуль Из Метаданные.ОбщиеМодули Цикл
		
		Если Модуль.РасширениеКонфигурации() <> Неопределено Тогда
			
			МетаданныеМодуля = МетаданныеМодуля(Модуль);
			МетаданныеМодулей.Добавить(МетаданныеМодуля);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МетаданныеМодулей;
	
КонецФункции

// Модули подсистемы.
//  Возвращает список модулей подсистемы
//  Подсистема должна находится в подсистеме "ЮТФункциональность"
// Параметры:
//  ИмяПодсистемы - Строка - Имя подсистемы
//  Серверные - Булево - Возвращять модули доступные на сервере
//  Клиентские - Булево - Возвращять модули доступные на клиенте
// 
// Возвращаемое значение:
//  Массив из Строка - Имена модулей входящих в подсистему
Функция МодулиПодсистемы(Знач ИмяПодсистемы, Знач Серверные, Знач Клиентские) Экспорт
	
	Подсистема = Метаданные.Подсистемы.ЮТФункциональность.Подсистемы.Найти(ИмяПодсистемы);
	
	Если Подсистема = Неопределено Тогда
		
		ВызватьИсключение СтрШаблон("Подсистема ""%1"" не найдена", ИмяПодсистемы);
		
	КонецЕсли;
	
	Модули = Новый Массив();
	
	Для Каждого Объект Из Подсистема.Состав Цикл
		
		Если Метаданные.ОбщиеМодули.Содержит(Объект) Тогда
			
			Добавить = (Серверные И Клиентские)
				ИЛИ (Серверные И (Объект.Сервер))
				ИЛИ (Клиентские И (Объект.КлиентУправляемоеПриложение Или Объект.ВызовСервера));
				// КлиентОбычноеПриложение сознательно не анализируется, он должен идти в паре с другой настройкой
			
			Если Добавить Тогда
				Модули.Добавить(Объект.Имя);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Модули;
	
КонецФункции

Функция МетаданныеМодуля(Знач Модуль) Экспорт
	
	Если ТипЗнч(Модуль) = Тип("Строка") Тогда
		ИмяМодуля = Модуль;
		Модуль = Метаданные.ОбщиеМодули.Найти(ИмяМодуля);
		
		Если Модуль = Неопределено Тогда
			ВызватьИсключение "Не найден модуль с именем " + ИмяМодуля;
		КонецЕсли;
	КонецЕсли;
	
	Описание = ЮТФабрика.ОписаниеМодуля();
	Описание.Имя = Модуль.Имя;
	Описание.КлиентУправляемоеПриложение = Модуль.КлиентУправляемоеПриложение;
	Описание.КлиентОбычноеПриложение = Модуль.КлиентОбычноеПриложение;
	Описание.Глобальный = Модуль.Глобальный;
	Описание.Сервер = Модуль.Сервер;
	Описание.ВызовСервера = Модуль.ВызовСервера;
	Описание.Расширение = Модуль.РасширениеКонфигурации().Имя;
	Описание.ПолноеИмя = СтрШаблон("%1.%2", Описание.Расширение, Модуль.Имя);
	
	Возврат Описание;
	
КонецФункции

Функция ОписаниеОбъектаМетаданных(Знач Значение, ЗаполнятьРеквизиты = Истина) Экспорт
	
	МетаданныеОбъекта = ОбъектМетаданных(Значение);
	ОписаниеТипа = ОписаниеТипаМетаданных(МетаданныеОбъекта);
	
	ОписаниеОбъект = Новый Структура;
	ОписаниеОбъект.Вставить("Имя", МетаданныеОбъекта.Имя);
	ОписаниеОбъект.Вставить("ОписаниеТипа", ОписаниеТипа);
	ОписаниеОбъект.Вставить("Реквизиты", Новый Структура());
	ОписаниеОбъект.Вставить("ТабличныеЧасти", Новый Структура());
	ЮТОбщий.УказатьТипСтруктуры(ОписаниеОбъект, "ОписаниеОбъектаМетаданных");
	
	Если НЕ ЗаполнятьРеквизиты Тогда
		Возврат ОписаниеОбъект;
	КонецЕсли;
	
	ДобавитьОписанияРеквизитов(МетаданныеОбъекта.СтандартныеРеквизиты, ОписаниеОбъект.Реквизиты, "Ссылка, Период");
	
	Если ОписаниеТипа.Измерения Тогда
		ДобавитьОписанияРеквизитов(МетаданныеОбъекта.Измерения, ОписаниеОбъект.Реквизиты, Истина);
	КонецЕсли;
	
	Если ОписаниеТипа.Реквизиты Тогда
		ДобавитьОписанияРеквизитов(МетаданныеОбъекта.Реквизиты, ОписаниеОбъект.Реквизиты, Ложь);
	КонецЕсли;
	
	Если ОписаниеТипа.Ресурсы Тогда
		ДобавитьОписанияРеквизитов(МетаданныеОбъекта.Ресурсы, ОписаниеОбъект.Реквизиты, Ложь);
	КонецЕсли;
	
	Если ОписаниеТипа.РеквизитыАдресации Тогда
		ДобавитьОписанияРеквизитов(МетаданныеОбъекта.РеквизитыАдресации, ОписаниеОбъект.Реквизиты, Ложь);
	КонецЕсли;
	
	Если ОписаниеТипа.ТабличныеЧасти Тогда
		
		Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
			РеквизитыТабличнойЧасти = Новый Структура();
			ДобавитьОписанияРеквизитов(ТабличнаяЧасть.Реквизиты, РеквизитыТабличнойЧасти, Ложь);
			
			ОписаниеОбъект.ТабличныеЧасти.Вставить(ТабличнаяЧасть.Имя, РеквизитыТабличнойЧасти);
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ОписаниеОбъект;
	
КонецФункции

// Описание типа метаданных.
// 
// Параметры:
//  МетаданныеОбъекта - Тип, ОбъектМетаданных - Тип
// 
// Возвращаемое значение:
//  Структура - Описание типа метаданных:
//  * Имя - Строка
//  * ИмяКоллекции - Строка
//  * Конструктор - Строка
//  * Группы - Булево
//  * Ссылочный - Булево
//  * Реквизиты - Булево
//  * Измерения - Булево
//  * Ресурсы - Булево
//  * РеквизитыАдресации - Булево
//  * ТабличныеЧасти - Булево
Функция ОписаниеТипаМетаданных(Знач МетаданныеОбъекта) Экспорт
	
	Если ТипЗнч(МетаданныеОбъекта) = Тип("Тип") Тогда
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(МетаданныеОбъекта);
	КонецЕсли;
	
	ПолноеИмя = МетаданныеОбъекта.ПолноеИмя();
	ЧастиИмени = СтрРазделить(ПолноеИмя, ".");
	Типы = ЮТМетаданные.ТипыМетаданных();
	
	Возврат Типы[ЧастиИмени[0]];
	
КонецФункции

Функция ТипыМетаданных() Экспорт
	
	Макет = ПолучитьОбщийМакет("ЮТОписаниеМетаданных").ПолучитьТекст();
	КоллекцияОписаний = ЮТТестовыеДанные.ТаблицаMarkDown(Макет);
	
	ТипыМетаданных = Новый Структура();
	
	Для Каждого Запись Из КоллекцияОписаний Цикл
		
		Описание = Новый Структура();
		Описание.Вставить("Имя", Запись.Имя);
		Описание.Вставить("ИмяКоллекции", Запись.ИмяКоллекции);
		Описание.Вставить("Конструктор", Запись.Конструктор);
		Описание.Вставить("Группы", Запись.Группы = "+");
		Описание.Вставить("Ссылочный", Запись.Ссылочный = "+");
		Описание.Вставить("Реквизиты", Запись.Реквизиты = "+");
		Описание.Вставить("Измерения", Запись.Измерения = "+");
		Описание.Вставить("Ресурсы", Запись.Ресурсы = "+");
		Описание.Вставить("РеквизитыАдресации", Запись.РеквизитыАдресации = "+");
		Описание.Вставить("ТабличныеЧасти", Запись.ТабличныеЧасти = "+");
		
		ТипыМетаданных.Вставить(Описание.Имя, Описание);
		ТипыМетаданных.Вставить(Описание.ИмяКоллекции, Описание);
		
	КонецЦикла;
	
	Возврат ТипыМетаданных;
	
КонецФункции

Функция РазрешеныСинхронныеВызовы() Экспорт
	
	Возврат Метаданные.РежимИспользованияСинхронныхВызововРасширенийПлатформыИВнешнихКомпонент
		= Метаданные.СвойстваОбъектов.РежимИспользованияСинхронныхВызововРасширенийПлатформыИВнешнихКомпонент.Использовать;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОбъектМетаданных(Значение)
	
	ТипЗначение = ТипЗнч(Значение);
	
	Если ТипЗначение = Тип("Тип") Тогда
		
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Значение);
		
	ИначеЕсли ТипЗначение = Тип("ОбъектМетаданных") Тогда
		
		ОбъектМетаданных = Значение;
		
	ИначеЕсли ТипЗначение = Тип("Строка") Тогда
		
		ЧастиСтроки = СтрРазделить(Значение, ".");
		
		Если ЧастиСтроки.Количество() = 2 Тогда
			
			ТипыМетаданных = ЮТМетаданные.ТипыМетаданных();
			ОписаниеТипа = ТипыМетаданных[ЧастиСтроки[0]];
			Если ОписаниеТипа <> Неопределено Тогда
				ОбъектМетаданных = Метаданные[ОписаниеТипа.ИмяКоллекции][ЧастиСтроки[1]];
			КонецЕсли;
			
		КонецЕсли;
		
	Иначе
		
		ОбъектМетаданных = Неопределено;
		
	КонецЕсли;
	
	Если ОбъектМетаданных = Неопределено Тогда
		Сообщение = ЮТОбщий.НеподдерживаемыйПараметрМетода("ЮТМетаданныеСервер.ОбъектМетаданных", Значение);
		ВызватьИсключение Сообщение;
	КонецЕсли;
	
	Возврат ОбъектМетаданных;
	
КонецФункции

Процедура ДобавитьОписанияРеквизитов(КоллекцияРеквизитов, КоллекцияОписаний, Знач ЭтоКлюч)
	
	Если ТипЗнч(ЭтоКлюч) = Тип("Строка") Тогда
		ИменаКлючевыхПолей = СтрРазделить(ЭтоКлюч, ", ");
	КонецЕсли;
	
	Для Каждого Реквизит Из КоллекцияРеквизитов Цикл
		
		Если ИменаКлючевыхПолей <> Неопределено Тогда
			ЭтоКлюч = ИменаКлючевыхПолей.Найти(Реквизит.Имя) <> Неопределено;
		КонецЕсли;
		
		КоллекцияОписаний.Вставить(Реквизит.Имя, ЮТФабрика.ОписаниеРеквизита(Реквизит, ЭтоКлюч));
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
