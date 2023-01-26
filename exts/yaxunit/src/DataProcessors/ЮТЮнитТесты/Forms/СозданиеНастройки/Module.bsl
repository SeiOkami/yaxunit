//©///////////////////////////////////////////////////////////////////////////©//
//
//  Copyright 2021-2022 BIA-Technologies Limited Liability Company
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

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОтобразитьОтчет = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьДеревоТестов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ФайлКонфигурацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьФайл("*.json|*.json", ФайлКонфигурации, Новый ОписаниеОповещения("УстановитьФайлКонфигурации", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапускИзПредприятияПриИзменении(Элемент)
	
	ОбновитьСтрокуЗапуска();
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлКонфигурацииПриИзменении(Элемент)
	
	ОбновитьСтрокуЗапуска();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводЛогаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьФайл("*.log|*.log|*.txt|*.txt|All files(*.*)|*.*", ИмяФайлаЛога, Новый ОписаниеОповещения("УстановитьИмяФайлаЛога", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоТестов

&НаКлиенте
Процедура ДеревоТестовОтметкаПриИзменении(Элемент)
	
	Данные = Элементы.ДеревоТестов.ТекущиеДанные;
	
	Если Данные.Отметка = 2 Тогда
		Данные.Отметка = 0;
	КонецЕсли;
	
	УстановитьРекурсивноЗначение(Данные.ПолучитьЭлементы(), Данные.Отметка);
	ОбновитьОтметкиРодителей(Данные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьРекурсивноЗначение(ДеревоТестов.ПолучитьЭлементы(), 0);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьРекурсивноЗначение(ДеревоТестов.ПолучитьЭлементы(), 1);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПараметры(Команда)
	
	Если НЕ ЕстьОтмеченныеТесты() Тогда
		ПоказатьПредупреждение(, "Отметьте тесты, которые должны выполниться");
		Возврат;
	КонецЕсли;
	
	Если ПустаяСтрока(ФайлКонфигурации) Тогда
		Обработчик = Новый ОписаниеОповещения("СохранитьПараметрыПослеВыбораФайла", ЭтотОбъект);
		ВыбратьФайл("*.json|*.json", ФайлКонфигурации, Обработчик);
	Иначе
		СохранитьПараметрыПослеВыбораФайла(ФайлКонфигурации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьДеревоТестов()
	
	ЮТКонтекст.ИнициализироватьКонтекст();
	ТестовыеМодули = ЮТЧитатель.ЗагрузитьТесты(Новый Структура("filter", Новый Структура));
	ЮТКонтекст.УдалитьКонтекст();
	
	СтрокиРасширений = Новый Соответствие();
	
	Для Каждого ОписаниеМодуля Из ТестовыеМодули Цикл
		
		ИмяРасширения = ОписаниеМодуля.МетаданныеМодуля.Расширение;
		
		СтрокаРасширения = СтрокиРасширений[ИмяРасширения];
		Если СтрокаРасширения = Неопределено Тогда
			СтрокаРасширения = ДобавитьСтрокуРасширения(ДеревоТестов, ИмяРасширения);
			СтрокиРасширений.Вставить(ИмяРасширения, СтрокаРасширения);
		КонецЕсли;
		
		СтрокаМодуля = ДобавитьСтрокуМодуля(СтрокаРасширения, ОписаниеМодуля.МетаданныеМодуля);
		
		Если ОписаниеМодуля.НаборыТестов.Количество() = 1 Тогда
			
			Для Каждого Тест Из ОписаниеМодуля.НаборыТестов[0].Тесты Цикл
				
				ДобавитьСтрокуТеста(СтрокаМодуля, Тест);
				
			КонецЦикла;
			
		Иначе
			
			Для Каждого Набор Из ОписаниеМодуля.НаборыТестов Цикл
				
				СтрокаНабора = ДобавитьСтрокуНабора(СтрокаМодуля, Набор);
				
				Для Каждого Тест Из Набор.Тесты Цикл
					
					ДобавитьСтрокуТеста(СтрокаНабора, Тест);
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьСтрокуРасширения(Владелец, ИмяРасширения)
	
	Строка = Владелец.ПолучитьЭлементы().Добавить();
	Строка.Идентификатор = ИмяРасширения;
	Строка.Представление = ИмяРасширения;
	Строка.ТипОбъекта = 0;
	
	Возврат Строка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьСтрокуМодуля(Владелец, МетаданныеМодуля)
	
	Строка = Владелец.ПолучитьЭлементы().Добавить();
	Строка.Идентификатор = МетаданныеМодуля.Имя;
	Строка.Представление = МетаданныеМодуля.Имя;
	Строка.ТипОбъекта = 1;
	
	Возврат Строка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьСтрокуНабора(Владелец, Набор)
	
	Строка = Владелец.ПолучитьЭлементы().Добавить();
	Строка.Идентификатор = Набор.Имя;
	Строка.Представление = Набор.Представление;
	Строка.ТипОбъекта = 2;
	
	Возврат Строка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДобавитьСтрокуТеста(Владелец, Тест)
	
	Представление = ЮТФабрика.ПредставлениеТеста(Тест);
	
	Если Владелец.ТипОбъекта = 1 Тогда
		СтрокаМодуля = Владелец;
	Иначе
		СтрокаМодуля = Владелец.ПолучитьРодителя();
	КонецЕсли;
	
	Строка = Владелец.ПолучитьЭлементы().Добавить();
	Строка.Идентификатор = СтрШаблон("%1.%2", СтрокаМодуля.Идентификатор, Тест.Имя);
	Строка.Представление = СтрШаблон("%1, %2", Представление, СтрСоединить(Тест.КонтекстВызова, ", "));
	Строка.ТипОбъекта = 3;
	
	Возврат Строка;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьРекурсивноЗначение(Элементы, Значение, Колонка = "Отметка")
	
	Для Каждого Элемент Из Элементы Цикл
		
		Элемент[Колонка] = Значение;
		
		Если ЗначениеЗаполнено(Элемент.ПолучитьЭлементы()) Тогда
			УстановитьРекурсивноЗначение(Элемент.ПолучитьЭлементы(), Значение, Колонка);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОтметкиРодителей(Элемент)
	
	Родитель = Элемент.ПолучитьРодителя();
	
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьСОтметкой = Ложь;
	ЕстьБезОтметки = Ложь;
	
	Для Каждого Элемент Из Родитель.ПолучитьЭлементы() Цикл
		
		Если Элемент.Отметка = 0 Тогда
			ЕстьБезОтметки = Истина;
		ИначеЕсли Элемент.Отметка = 1 Тогда
			ЕстьСОтметкой = Истина;
		ИначеЕсли Элемент.Отметка = 2 Тогда
			ЕстьБезОтметки = Истина;
			ЕстьСОтметкой = Истина;
		КонецЕсли;
		
		Если ЕстьБезОтметки И ЕстьСОтметкой Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЕстьСОтметкой И ЕстьБезОтметки Тогда
		НоваяОтметка = 2;
	ИначеЕсли ЕстьСОтметкой Тогда
		НоваяОтметка = 1;
	Иначе
		НоваяОтметка = 0;
	КонецЕсли;
	
	Если Родитель.Отметка = НоваяОтметка Тогда
		Возврат;
	КонецЕсли;
	
	Родитель.Отметка = НоваяОтметка;
	ОбновитьОтметкиРодителей(Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтрокуЗапуска()
	
	ПараметрыЗапускаЮнитТестов = СтрШаблон("%1=%2", ЮТПараметры.КлючЗапуска(), ФайлКонфигурации);
	
	Если ЗапускИзКонфигуратор Тогда
		
		ПараметрыЗапуска = ПараметрыЗапускаЮнитТестов;
		
	Иначе
		
#Если ВебКлиент Тогда
		ВызватьИсключение "Формирование строки запуска для веб-клиенте не поддерживается";
#Иначе
		СистемнаяИнформация = Новый СистемнаяИнформация;
#Если ТонкийКлиент Тогда
		Файл = "1cv8c";
#Иначе
		Файл = "1cv8";
#КонецЕсли
		ПутьЗапускаемогоКлиента = ЮТОбщий.ОбъединитьПути(КаталогПрограммы(), Файл);
		
		Если СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86 Или СистемнаяИнформация.ТипПлатформы
			= ТипПлатформы.Windows_x86_64 Тогда
			ПутьЗапускаемогоКлиента = ПутьЗапускаемогоКлиента + ".exe";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ИмяПользователя()) Тогда
			Пользователь = СтрШаблон("/N""%1""", ИмяПользователя());
		Иначе
			Пользователь = "";
		КонецЕсли;
		
		ПараметрыЗапуска = СтрШаблон("""%1"" %2 /IBConnectionString ""%3"" /C""%4""",
									 ПутьЗапускаемогоКлиента,
									 Пользователь,
									 СтрЗаменить(СтрокаСоединенияИнформационнойБазы(), """", """"""),
									 ПараметрыЗапускаЮнитТестов);
#КонецЕсли
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПараметрыПослеВыбораФайла(ВыбранныйФайл, ДополнительныеПараметры = Неопределено) Экспорт
	
	ФайлКонфигурации = ВыбранныйФайл;
	ОбновитьСтрокуЗапуска();
	СохранитьКонфигурациюЗапуска();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФайлКонфигурации(ВыбранныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйФайл <> Неопределено Тогда
		ФайлКонфигурации = ВыбранныйФайл;
		ОбновитьСтрокуЗапуска();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИмяФайлаЛога(ВыбранныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйФайл <> Неопределено Тогда
		ИмяФайлаЛога = ВыбранныйФайл;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайл(Фильтр, ИмяФайла, Оповещение)
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ДиалогВыбораФайла.Фильтр = Фильтр;
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.ПолноеИмяФайла = ИмяФайла;
	
	ПараметрыОбработчика = Новый Структура("Оповещение", Оповещение);
	Обработчик = Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтотОбъект, ПараметрыОбработчика);
	ДиалогВыбораФайла.Показать(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.Оповещение, ВыбранныеФайлы[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКонфигурациюЗапуска()
	
#Если ВебКлиент Тогда
	ВызватьИсключение "Сохранение конфигурации из веб-клиента не поддерживается";
#Иначе
	Конфигурация = ЮТФабрика.ПараметрыЗапуска();
	Конфигурация.showReport = ОтобразитьОтчет;
	Конфигурация.closeAfterTests = Истина;
	Конфигурация.reportPath = ЮТОбщий.Каталог(ФайлКонфигурации);
	Конфигурация.Удалить("ВыполнятьМодульноеТестирование");
	Конфигурация.logging.enable = ЗначениеЗаполнено(ИмяФайлаЛога);
	Конфигурация.logging.file = ИмяФайлаЛога;
	
	Если НЕ (УстановленФильтрПоРасширению(Конфигурация) ИЛИ УстановленФильтрПоМодулям(Конфигурация)) Тогда
		УстановитьФильтрПоТестам(Конфигурация);
	КонецЕсли;
	
	Запись = Новый ЗаписьJSON();
	СимволыОтступа = "  ";
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(, СимволыОтступа);
	Запись.ОткрытьФайл(ФайлКонфигурации, , , ПараметрыЗаписи);
	ЗаписатьJSON(Запись, Конфигурация);
	Запись.Закрыть();
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьОтмеченныеТесты()
	
	Для Каждого СтрокаРасширения Из ДеревоТестов.ПолучитьЭлементы() Цикл
		Если СтрокаРасширения.Отметка > 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Функция УстановленФильтрПоРасширению(Конфигурация)
	
	Расширения = Новый Массив();
	Для Каждого СтрокаРасширения Из ДеревоТестов.ПолучитьЭлементы() Цикл
		
		Если СтрокаРасширения.Отметка = 2 Тогда
			Возврат Ложь;
		ИначеЕсли СтрокаРасширения.Отметка = 1 Тогда
			Расширения.Добавить(СтрокаРасширения.Идентификатор);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Расширения.Количество() Тогда
		Конфигурация.filter.extensions = Расширения;
	КонецЕсли;
	
	Возврат Расширения.Количество() > 0;
	
КонецФункции

&НаКлиенте
Функция УстановленФильтрПоМодулям(Конфигурация)
	
	Модули = Новый Массив();
	
	Для Каждого СтрокаРасширения Из ДеревоТестов.ПолучитьЭлементы() Цикл
		
		Если СтрокаРасширения.Отметка = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого СтрокаМодуля Из СтрокаРасширения.ПолучитьЭлементы() Цикл
			
			Если СтрокаМодуля.Отметка = 2 Тогда
				Возврат Ложь;
			ИначеЕсли СтрокаМодуля.Отметка = 1 Тогда
				Модули.Добавить(СтрокаМодуля.Идентификатор);
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если Модули.Количество() Тогда
		Конфигурация.filter.modules = Модули;
	КонецЕсли;
	
	Возврат Модули.Количество() > 0;
	
КонецФункции

&НаКлиенте
Процедура УстановитьФильтрПоТестам(Конфигурация)
	
	Тесты = Новый Массив();
	ДобавитьОтмеченныеТесты(ДеревоТестов.ПолучитьЭлементы(), Тесты);
	
	Конфигурация.filter.tests = Тесты;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьОтмеченныеТесты(Строки, Тесты)
	
	Для Каждого Строка Из Строки Цикл
		Если Строка.Отметка = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если Строка.ТипОбъекта = 3 Тогда
			Тесты.Добавить(Строка.Идентификатор);
		Иначе
			ДобавитьОтмеченныеТесты(Строка.ПолучитьЭлементы(), Тесты);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
