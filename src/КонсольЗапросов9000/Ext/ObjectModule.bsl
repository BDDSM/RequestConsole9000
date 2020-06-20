﻿// Консоль запросов 9000 v 1.1.7
// (C) Александр Кузнецов 2019-2020
// hal@hal9000.cc
//Минимальная версия платформы 8.3.12, минимальный режим совместимости 8.3.8

Процедура Инициализация(Форма = Неопределено, чСеансИД = Неопределено) Экспорт
	
	ВерсияОбработки = "1.1.7";
	Хэширование = Новый ХешированиеДанных(ХешФункция.CRC32);
	Хэширование.Добавить(СтрокаСоединенияИнформационнойБазы());
	СтрокаИБ = Формат(Хэширование.ХешСумма, "ЧГ=0");
	
	Если чСеансИД = Неопределено Тогда
		Хэширование.Добавить(ИмяПользователя());
		СеансИД = Хэширование.ХешСумма;
	Иначе
		СеансИД = чСеансИД;
	КонецЕсли;
	
	РасширениеЗахваченныхЗапросов = "9000_" + Формат(СеансИД, "ЧГ=0");
	ИмяФайлаОбработки = ИспользуемоеИмяФайла;
	
	Если Форма <> Неопределено Тогда
		
		МакетКартинок = ПолучитьМакет("Картинки");
		стКартинки = Новый Структура;
		Для Каждого Область ИЗ МакетКартинок.Области Цикл
			Если ТипЗнч(Область) = Тип("РисунокТабличногоДокумента") Тогда
				стКартинки.Вставить(Область.Имя, Область.Картинка);
			КонецЕсли;
		КонецЦикла;
		
		Картинки = ПоместитьВоВременноеХранилище(стКартинки, Форма.УникальныйИдентификатор); 
		
	КонецЕсли;
	
КонецПроцедуры

Функция СтрокаВЗначение(стрЗначение) Экспорт
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(стрЗначение);
	Возврат СериализаторXDTO.ПрочитатьXML(Чтение);
КонецФункции

Функция ЗначениеВСтроку(Значение) Экспорт
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьXML(Запись, Значение);
	Возврат Запись.Закрыть();
КонецФункции

Функция ПолучитьИмяТипа(Значение) Экспорт
	
	ъ = Новый Массив;
	ъ.Добавить(Значение);
	ОписаниеТиповЗначения = Новый ОписаниеТипов(ъ);
	ЗначениеТипа = ОписаниеТиповЗначения.ПривестиЗначение(Неопределено);
	
	Если Значение = Тип("Неопределено") Тогда
		Возврат "Неопределено";
	ИначеЕсли Справочники.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "СправочникСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "ДокументСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "ПеречислениеСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "ПланВидовХарактеристикСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "ПланСчетовСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "ПланВидовРасчетаСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "БизнесПроцессСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли Задачи.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "ЗадачаСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли ПланыОбмена.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "ПланОбменаСсылка." + ЗначениеТипа.Метаданные().Имя;
	ИначеЕсли Значение = Тип("Null") Тогда
		Возврат "Null";
	ИначеЕсли Значение = Тип("ВидДвиженияБухгалтерии") Тогда
		Возврат "ВидДвиженияБухгалтерии";
	ИначеЕсли Значение = Тип("ВидДвиженияНакопления") Тогда
		Возврат "ВидДвиженияНакопления";
	ИначеЕсли Значение = Тип("ВидСчета") Тогда
		Возврат "ВидСчета";
	Иначе
		Возврат Строка(Значение);
	КонецЕсли;
	
КонецФункции

Функция ПолучитьНеотображаемыеНаКлиентеТипы()
	маТипы = Новый Массив;
	маТипы.Добавить(Тип("Тип"));
	маТипы.Добавить(Тип("МоментВремени"));
	маТипы.Добавить(Тип("Граница"));
	маТипы.Добавить(Тип("ХранилищеЗначения"));
	маТипы.Добавить(Тип("РезультатЗапроса"));
	Возврат маТипы;
КонецФункции

Функция СписокЗначенийИзМассива(маМассив)
	сзСписок = Новый СписокЗначений;
	сзСписок.ЗагрузитьЗначения(маМассив);
	Возврат сзСписок;
КонецФункции

Процедура ИзменитьТипКолонкиТаблицыЗначений(тзДанные, стрИмяКолонки, НовыйТипКолонки) Экспорт
	стрИмяВременнойКолонки = стрИмяКолонки + "_Вр31415926";
	маДанныеКолонки = тзДанные.ВыгрузитьКолонку(стрИмяКолонки);
	тзДанные.Колонки.Добавить(стрИмяВременнойКолонки, НовыйТипКолонки);
	тзДанные.ЗагрузитьКолонку(маДанныеКолонки, стрИмяВременнойКолонки);
	тзДанные.Колонки.Удалить(стрИмяКолонки);
	тзДанные.Колонки[стрИмяВременнойКолонки].Имя = стрИмяКолонки;
КонецПроцедуры

//Удаляет NULL из типа колонок, если в них нет значений NULL
Процедура ТаблицаЗначений_УдалитьТипNull(тзТаблица) Экспорт
	
	маВычитаемыеТипы = Новый Массив;
	маВычитаемыеТипы.Добавить(Тип("Null"));
	
	стКолонкиДляОбработки = Новый Структура;
	тзНоваяТаблица = Новый ТаблицаЗначений;
	Для Каждого Колонка Из тзТаблица.Колонки Цикл
		
		Если Колонка.ТипЗначения.СодержитТип(Тип("Null")) Тогда
			маСтрокиСNull = тзТаблица.НайтиСтроки(Новый Структура(Колонка.Имя, Null));
			Если маСтрокиСNull.Количество() = 0 Тогда
				стКолонкиДляОбработки.Вставить(Колонка.Имя);
				тзНоваяТаблица.Колонки.Добавить(Колонка.Имя, Новый ОписаниеТипов(Колонка.ТипЗначения, , маВычитаемыеТипы));
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		тзНоваяТаблица.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
		
	КонецЦикла;
	
	Если стКолонкиДляОбработки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из тзТаблица Цикл
		ЗаполнитьЗначенияСвойств(тзНоваяТаблица.Добавить(), Строка);
	КонецЦикла;
	
	тзТаблица = тзНоваяТаблица;
	
КонецПроцедуры

Процедура ОбработатьМакроколонки(РезультатЗапросаСтрока, выбВыборка, стМакроколонки) Экспорт
	Для Каждого кз Из стМакроколонки Цикл
		Если кз.Значение.Тип = "УИД" Тогда
			Значение = РезультатЗапросаСтрока[кз.Значение.КолонкаИсточника];
			Если ЗначениеЗаполнено(Значение) Тогда
				РезультатЗапросаСтрока[кз.Ключ] = Значение.УникальныйИдентификатор();
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

//Сохраняемые состояния для всех форм (настройки, положения переключателей, состояния окон и т.д.)
#Область АдресСохраняемыеСостояния

Процедура СохраняемыеСостояния_Сохранить(ИмяЗначения, Значение) Экспорт
	
	стСохраняемыеСостояния = ПолучитьИзВременногоХранилища(АдресСохраняемыеСостояния);
	
	стСохраняемыеСостояния.Вставить(ИмяЗначения, Значение);
	
	ПоместитьВоВременноеХранилище(стСохраняемыеСостояния, АдресСохраняемыеСостояния);
	
	//Модифицрованность = Истина;
	
КонецПроцедуры

Функция СохраняемыеСостояния_Получить(ИмяЗначения, ЗначениеПоУмолчанию) Экспорт
	Перем Значение;
	
	стСохраняемыеСостояния = ПолучитьИзВременногоХранилища(АдресСохраняемыеСостояния);
	
	Если НЕ стСохраняемыеСостояния.Свойство(ИмяЗначения, Значение) Тогда
		Возврат ЗначениеПоУмолчанию;
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти

#Область ИнтерфейсСТаблицейЗначений

//Описание типов внутри содержит больше, чем это можно увидеть средствами языка.
//Например, там есть какая-то информация, которая прилетает туда из "определяемых типов" полей в запросе.
//Это приводит к некорректному поведению. Колонка не воспринимала отрицательные числа, хотя в типе точно стаяло в квалификаторах числа знак "Любой".
//Эта функция пересоздает описание типов, что бы там внутри не было ничего лишнего.
Функция НормализоватьТип(НекоеОписаниеТипов)
	
	Типы = НекоеОписаниеТипов.Типы();
	НовоеОписаниеТипов = Новый ОписаниеТипов(Типы, НекоеОписаниеТипов.КвалификаторыЧисла, НекоеОписаниеТипов.КвалификаторыСтроки, НекоеОписаниеТипов.КвалификаторыДаты);
	
	Возврат НовоеОписаниеТипов;
	
КонецФункции

Процедура СоздатьРеквизитыТаблицыПоКолонкам(Форма, ИмяРеквизитаТаблицыФормы, ИмяРеквизитаСоответствияКолонок, ИмяРеквизитаКолонкиКонтейнера, Колонки, фДляРедактирования = Ложь, стМакроколонки = Неопределено) Экспорт
	
	маНеотображаемыеТипы = ПолучитьНеотображаемыеНаКлиентеТипы();
	
	ИмяРеквизитаТаблицыФормыИтоги = ИмяРеквизитаТаблицыФормы + "Итоги";
	фЕстьИтоги = Ложь;
	Для Каждого Реквизит Из Форма.ПолучитьРеквизиты() Цикл
		Если Реквизит.Имя = ИмяРеквизитаТаблицыФормыИтоги Тогда
			фЕстьИтоги = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	маУдаляемыеРеквизиты = Новый Массив;
	
	Если ТипЗнч(Форма[ИмяРеквизитаТаблицыФормы]) = Тип("ДанныеФормыКоллекция") Тогда
		Форма[ИмяРеквизитаТаблицыФормы].Очистить();
	КонецЕсли;
	
	Для Каждого Реквизит Из Форма.ПолучитьРеквизиты(ИмяРеквизитаТаблицыФормы) Цикл
		маУдаляемыеРеквизиты.Добавить(Реквизит.Путь + "." + Реквизит.Имя);
	КонецЦикла;
	
	Если фЕстьИтоги Тогда
		Форма[ИмяРеквизитаТаблицыФормыИтоги].Очистить();
		Для Каждого Реквизит Из Форма.ПолучитьРеквизиты(ИмяРеквизитаТаблицыФормыИтоги) Цикл
			маУдаляемыеРеквизиты.Добавить(Реквизит.Путь + "." + Реквизит.Имя);
		КонецЦикла;
	КонецЕсли;
	
	стКолонкиКонтейнера = Новый Структура;
	маДобавляемыеРеквизиты = Новый Массив;
	Если Колонки <> Неопределено Тогда
		
		Для Каждого Колонка Из Колонки Цикл
			
			стМакроколонка = Неопределено;
			Если стМакроколонки <> Неопределено И стМакроколонки.Свойство(Колонка.Имя, стМакроколонка) Тогда
				ТипКолонки = стМакроколонка.ТипЗначения;
			Иначе
				ТипКолонки = Колонка.ТипЗначения;
			КонецЕсли;
			
			фЕстьНеотображаемыеТипы = Ложь;
			Для Каждого НеотображаемыйТип Из маНеотображаемыеТипы Цикл
				Если ТипКолонки.СодержитТип(НеотображаемыйТип) Тогда
					фЕстьНеотображаемыеТипы = Истина;
					Прервать;
				КонецЕсли;
			КонецЦикла;
				
			Если фЕстьНеотображаемыеТипы Тогда
				
				стрИмяКолонкиКонтейнера = Колонка.Имя + "_31415926Контейнер";
				Реквизит = Новый РеквизитФормы(стрИмяКолонкиКонтейнера, Новый ОписаниеТипов(), ИмяРеквизитаТаблицыФормы, стрИмяКолонкиКонтейнера);
				маДобавляемыеРеквизиты.Добавить(Реквизит);
				стКолонкиКонтейнера.Вставить(Колонка.Имя, ТипКолонки);
				
				ТипКолонкиТаблицы = Новый ОписаниеТипов(ТипКолонки, "Строка", маНеотображаемыеТипы);
				
			Иначе
				ТипКолонкиТаблицы = НормализоватьТип(ТипКолонки);
			КонецЕсли;
				
			Если ТипКолонкиТаблицы.СодержитТип(Тип("Число")) Тогда
				ТипКолонкиИтогов = Новый ОписаниеТипов("Число", ТипКолонкиТаблицы.КвалификаторыЧисла);
			Иначе
				ТипКолонкиИтогов = Новый ОписаниеТипов("Null");
			КонецЕсли;
			
			Реквизит = Новый РеквизитФормы(Колонка.Имя, ТипКолонкиТаблицы, ИмяРеквизитаТаблицыФормы, Колонка.Имя);
			маДобавляемыеРеквизиты.Добавить(Реквизит);
			
			Если фЕстьИтоги Тогда
				Реквизит = Новый РеквизитФормы(Колонка.Имя, ТипКолонкиИтогов, ИмяРеквизитаТаблицыФормыИтоги, Колонка.Имя);
				маДобавляемыеРеквизиты.Добавить(Реквизит);
			КонецЕсли;
			
		КонецЦикла;                                                 
		
	КонецЕсли;
	
	Форма.ИзменитьРеквизиты(маДобавляемыеРеквизиты, маУдаляемыеРеквизиты);
	
	Если фЕстьИтоги Тогда
		Форма[ИмяРеквизитаТаблицыФормыИтоги].Добавить();
	КонецЕсли;
	
	Пока Форма.Элементы[ИмяРеквизитаТаблицыФормы].ПодчиненныеЭлементы.Количество() > 0 Цикл
		Форма.Элементы.Удалить(Форма.Элементы[ИмяРеквизитаТаблицыФормы].ПодчиненныеЭлементы[0]);
	КонецЦикла;
	
	стКолонкиРезультата = Новый Структура;
	Если Колонки <> Неопределено Тогда
		
		Для Каждого Колонка Из Колонки Цикл
			
			стрИмяКолонки = ИмяРеквизитаТаблицыФормы + Колонка.Имя;
			стКолонкиРезультата.Вставить(стрИмяКолонки, Колонка.Имя);
			КолонкаТаблицы = Форма.Элементы.Добавить(стрИмяКолонки, Тип("ПолеФормы"), Форма.Элементы[ИмяРеквизитаТаблицыФормы]); 
			КолонкаТаблицы.ПутьКДанным = ИмяРеквизитаТаблицыФормы + "." + Колонка.Имя;
			
			Если фЕстьИтоги Тогда
				КолонкаТаблицы.ПутьКДаннымПодвала = ИмяРеквизитаТаблицыФормыИтоги + "[0]." + Колонка.Имя;
			КонецЕсли;

			Если фДляРедактирования Тогда
				
				КолонкаТаблицы.Вид = ВидПоляФормы.ПолеВвода;
				КолонкаТаблицы.РежимРедактирования = РежимРедактированияКолонки.Непосредственно;
				КолонкаТаблицы.КнопкаОчистки = Истина;
				
				Если стКолонкиКонтейнера.Свойство(Колонка.Имя) Тогда
					КолонкаТаблицы.КнопкаВыбора = Истина;
					КолонкаТаблицы.РедактированиеТекста = Ложь;
					КолонкаТаблицы.УстановитьДействие("НачалоВыбора", "ПолеТаблицыНачалоВыбора");
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Форма[ИмяРеквизитаСоответствияКолонок] = стКолонкиРезультата;
	Форма[ИмяРеквизитаКолонкиКонтейнера] = стКолонкиКонтейнера;
	
КонецПроцедуры

Процедура ИнициализироватьКонтейнерыСтрокиПоТипам(СтрокаТаблицы, ТаблицаЗначенийКолонкиКонтейнера) Экспорт
	
	Для Каждого кз Из ТаблицаЗначенийКолонкиКонтейнера Цикл
		
		ИмяКолонки = кз.Ключ;
		ТипЗначения = кз.Значение;
		маТипыЗначения = ТипЗначения.Типы();
		
		Контейнер = Неопределено;
		Если маТипыЗначения.Количество() = 1 Тогда
			
			Если ТипЗначения.СодержитТип(Тип("Тип")) Тогда
				Контейнер = Контейнер_СохранитьЗначение(Тип("Неопределено"));
			ИначеЕсли ТипЗначения.СодержитТип(Тип("МоментВремени")) Тогда
				Контейнер = Контейнер_СохранитьЗначение(Новый МоментВремени('00010101', Неопределено));
			КонецЕсли;
				
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Контейнер) Тогда
			Контейнер = ПустойКонтейнер();
		КонецЕсли;
		
		СтрокаТаблицы[ИмяКолонки + "_31415926Контейнер"] = Контейнер;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПустойКонтейнер()
	Возврат Новый Структура("Тип, Представление", , "???");
КонецФункции

//Контейнеры в таблице должны быть всегда.
//Если контейнер не нужен, и значение храниться в основном поле - добавляем пустой контейнер.
Процедура ДобавитьКонтейнеры(СтрокаТаблицыЗначенийРеквизита, СтрокаИсточник, КолонкиКонтейнера) Экспорт
	
	Для Каждого кз Из КолонкиКонтейнера Цикл
		
		стрИмяКолонки = кз.Ключ;
		стрИмяКолонкиКонтейнера = стрИмяКолонки + "_31415926Контейнер";
		
		Если ТипЗнч(СтрокаИсточник[стрИмяКолонки]) = Тип("РезультатЗапроса") Тогда
			Контейнер = Контейнер_СохранитьЗначение(СтрокаИсточник[кз.Ключ].Выгрузить());
		Иначе
			Контейнер = Контейнер_СохранитьЗначение(СтрокаИсточник[кз.Ключ]);
		КонецЕсли;
		
		Если ТипЗнч(Контейнер) <> Тип("Структура") Тогда
			Контейнер = ПустойКонтейнер();
		КонецЕсли;
		
		СтрокаТаблицыЗначенийРеквизита[стрИмяКолонкиКонтейнера] = Контейнер;
		СтрокаТаблицыЗначенийРеквизита[стрИмяКолонки] = Контейнер.Представление;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТаблицаВРеквизитыФормы(ТаблицаЗначений, ТаблицаЗначенийРеквизит, ТаблицаЗначенийКолонкиКонтейнераРеквизит) Экспорт
	
	фЕстьКонтейнеры = ТаблицаЗначенийКолонкиКонтейнераРеквизит.Количество() > 0;
	Если НЕ фЕстьКонтейнеры Тогда
		ТаблицаЗначенийРеквизит.Загрузить(ТаблицаЗначений);
	Иначе

		Для Каждого Строка Из ТаблицаЗначений Цикл
			СтрокаТаблицыЗначенийРеквизита = ТаблицаЗначенийРеквизит.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаТаблицыЗначенийРеквизита, Строка);
			Если фЕстьКонтейнеры Тогда
				ДобавитьКонтейнеры(СтрокаТаблицыЗначенийРеквизита, Строка, ТаблицаЗначенийКолонкиКонтейнераРеквизит);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецФункции
	
Функция ТаблицаИзРеквизитовФормы(ТаблицаЗначенийРеквизит, ТаблицаЗначенийКолонкиКонтейнераРеквизит) Экспорт
	
	тзДанные = ТаблицаЗначенийРеквизит.Выгрузить();
	
	Если ТаблицаЗначенийКолонкиКонтейнераРеквизит.Количество() = 0 Тогда
		Возврат Контейнер_СохранитьЗначение(тзДанные);
	КонецЕсли;
	
	стИменаКолонокКонтейнеров = Новый Структура;
	Для Каждого кз Из ТаблицаЗначенийКолонкиКонтейнераРеквизит Цикл
		стИменаКолонокКонтейнеров.Вставить(кз.Ключ + "_31415926Контейнер");
	КонецЦикла;
	
	тзВозвращаемаяТаблица = Новый ТаблицаЗначений;
	Для Каждого Колонка Из тзДанные.Колонки Цикл
		
		Если стИменаКолонокКонтейнеров.Свойство(Колонка.Имя) Тогда
			Продолжить;
		КонецЕсли;
		
		ТипКолонки = Колонка.ТипЗначения;
		ТаблицаЗначенийКолонкиКонтейнераРеквизит.Свойство(Колонка.Имя, ТипКолонки);
		тзВозвращаемаяТаблица.Колонки.Добавить(Колонка.Имя, ТипКолонки)
		
	КонецЦикла;
	
	чКоличествоСтрок = тзДанные.Количество();
	Для Каждого СтрокаТаблицыЗначенийРеквизита Из ТаблицаЗначенийРеквизит Цикл
		Строка = тзВозвращаемаяТаблица.Добавить();
		ЗаполнитьЗначенияСвойств(Строка, СтрокаТаблицыЗначенийРеквизита);
		Для Каждого кз Из ТаблицаЗначенийКолонкиКонтейнераРеквизит Цикл
			ИмяКолонки = кз.Ключ;
			Строка[ИмяКолонки] = Контейнер_ВосстановитьЗначение(СтрокаТаблицыЗначенийРеквизита[ИмяКолонки + "_31415926Контейнер"]);
		КонецЦикла;
	КонецЦикла;
		
	Возврат Контейнер_СохранитьЗначение(тзВозвращаемаяТаблица);
	
КонецФункции

#КонецОбласти

#Область Контейнер

//Таблица значений может быть как есть, либо уже сериализованная и положенная в структуру-контейнер.
//Контейнер для параметров и для таблиц имеет немного разное значение.
//Для параметра: там может лежать либо само значение, либо структура для списка значений, массива или специального типа.
//Для таблицы: всегда структура для специального типа.

Функция Контейнер_Очистить(Контейнер) Экспорт
	
	Если Контейнер.Тип = "ТаблицаЗначений" Тогда
		Значение = Контейнер_ВосстановитьЗначение(Контейнер);
		Значение.Очистить();
	ИначеЕсли Контейнер.Тип = "СписокЗначений" Тогда
		Значение = Контейнер_ВосстановитьЗначение(Контейнер);
		Значение.Очистить();
	ИначеЕсли Контейнер.Тип = "Массив" Тогда
		Значение = Новый Массив;
	ИначеЕсли Контейнер.Тип = "Тип" Тогда
		Значение = Тип("Неопределено");
	ИначеЕсли Контейнер.Тип = "Граница" Тогда
		Значение = Новый Граница(, ВидГраницы.Включая);
	ИначеЕсли Контейнер.Тип = "МоментВремени" Тогда
		Значение = Новый МоментВремени('00010101');
	ИначеЕсли Контейнер.Тип = "ХранилищеЗначения" Тогда
		Значение = Новый ХранилищеЗначения(Неопределено);
	Иначе
		ВызватьИсключение "Неизвестный тип контейнера";
	КонецЕсли;
	
	Контейнер_СохранитьЗначение(Значение);
	
КонецФункции

Функция Контейнер_СохранитьЗначение(Значение) Экспорт
	
	ТипЗначения = ТипЗнч(Значение);
	Если ТипЗначения = Тип("Граница") Тогда
		Результат = Новый Структура("Тип, ВидГраницы, Значение, Представление", "Граница");
		ЗаполнитьЗначенияСвойств(Результат, Значение);
		Результат.ВидГраницы = Строка(Результат.ВидГраницы);
		Результат.Представление = Контейнер_ПолучитьПредставление(Результат);
	ИначеЕсли ТипЗначения = Тип("МоментВремени") Тогда
		Результат = Новый Структура("Тип, Дата, Ссылка, Представление", "МоментВремени");
		ЗаполнитьЗначенияСвойств(Результат, Значение);
		Результат.Представление = Контейнер_ПолучитьПредставление(Результат);
	ИначеЕсли ТипЗначения = Тип("Тип") Тогда
		Результат = Новый Структура("Тип, ИмяТипа, Представление", "Тип", ПолучитьИмяТипа(Значение));
		Результат.Представление = Контейнер_ПолучитьПредставление(Результат);
	ИначеЕсли ТипЗначения = Тип("ХранилищеЗначения") Тогда
		Результат = Новый Структура("Тип, Хранилище, Представление", "ХранилищеЗначения", ЗначениеВСтроку(Значение));
		Результат.Представление = Контейнер_ПолучитьПредставление(Результат);
	ИначеЕсли ТипЗначения = Тип("Массив") Тогда
		Результат = Новый Структура("Тип, СписокЗначений, Представление", "Массив", СписокЗначенийИзМассива(Значение));
		Результат.Представление = Контейнер_ПолучитьПредставление(Результат);
	ИначеЕсли ТипЗначения = Тип("СписокЗначений") Тогда
		Результат = Новый Структура("Тип, СписокЗначений, Представление", "СписокЗначений", Значение);
		Результат.Представление = Контейнер_ПолучитьПредставление(Результат);
	ИначеЕсли ТипЗначения = Тип("ТаблицаЗначений") Тогда
		Результат = Новый Структура("Тип, КоличествоСтрок, Значение, Представление", "ТаблицаЗначений", Значение.Количество(), ЗначениеВСтроку(Значение));
		Результат.Представление = Контейнер_ПолучитьПредставление(Результат);
	Иначе
		Результат = Значение;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции

Функция Контейнер_ВосстановитьЗначение(СохраненноеЗначение) Экспорт
	
	Если ТипЗнч(СохраненноеЗначение) = Тип("Структура") Тогда
		Если СохраненноеЗначение.Тип = "Граница" Тогда
			Результат = Новый Граница(СохраненноеЗначение.Значение, ВидГраницы[СохраненноеЗначение.ВидГраницы]);
		ИначеЕсли СохраненноеЗначение.Тип = "МоментВремени" Тогда
			Результат = Новый МоментВремени(СохраненноеЗначение.Дата, СохраненноеЗначение.Ссылка);
		ИначеЕсли СохраненноеЗначение.Тип = "МоментВремени" Тогда
			Результат = СохраненноеЗначение.УникальныйИдентификатор;
		ИначеЕсли СохраненноеЗначение.Тип = "Тип" Тогда
			Результат = Тип(СохраненноеЗначение.ИмяТипа);
		ИначеЕсли СохраненноеЗначение.Тип = "СписокЗначений" Тогда
			Результат = СохраненноеЗначение.СписокЗначений;
		ИначеЕсли СохраненноеЗначение.Тип = "Массив" Тогда
			Результат = СохраненноеЗначение.СписокЗначений.ВыгрузитьЗначения();
		ИначеЕсли СохраненноеЗначение.Тип = "ТаблицаЗначений" Тогда
			Результат = СтрокаВЗначение(СохраненноеЗначение.Значение);
		КонецЕсли;
	Иначе
		Результат = СохраненноеЗначение;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция Контейнер_ПолучитьПредставление(Контейнер) Экспорт
	
	чРазмерПредставления = 200;
	
	Если ТипЗнч(Контейнер) = Тип("Структура") Тогда
		Если Контейнер.Тип = "Граница" Тогда
			Возврат Строка(Контейнер.Значение) + " " + Контейнер.ВидГраницы;
		ИначеЕсли Контейнер.Тип = "Массив" Тогда
			Возврат Лев(СтрСоединить(Контейнер.СписокЗначений.ВыгрузитьЗначения(), "; "), чРазмерПредставления);
		ИначеЕсли Контейнер.Тип = "СписокЗначений" Тогда
			Возврат Лев(СтрСоединить(Контейнер.СписокЗначений.ВыгрузитьЗначения(), "; "), чРазмерПредставления);
		ИначеЕсли Контейнер.Тип = "ТаблицаЗначений" Тогда
			КоличествоСтрок = Неопределено;
			Если Контейнер.Свойство("КоличествоСтрок", КоличествоСтрок) Тогда
				Возврат "<строк: " + КоличествоСтрок + ">";
			Иначе
				Возврат "<строк: ?>";
			КонецЕсли;
		ИначеЕсли Контейнер.Тип = "МоментВремени" Тогда
			Возврат Строка(Контейнер.Дата) + "; " + Контейнер.Ссылка;
		ИначеЕсли Контейнер.Тип = "Тип" Тогда
			Возврат "Тип: " + Тип(Контейнер.ИмяТипа);
		ИначеЕсли Контейнер.Тип = "ХранилищеЗначения" Тогда
			Возврат "<ХранилищеЗначения>";
		КонецЕсли;
	Иначе
		Возврат "???";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

Функция СохранитьЗапрос(чСеансИД, Запрос) Экспорт
	
	Если ТипЗнч(чСеансИД) <> Тип("Число") Тогда
		Возврат "!Не верный тип параметра 1: " + ТипЗнч(чСеансИД) + ". Должен быть тип ""Число""";
	КонецЕсли;
	
	Если ТипЗнч(Запрос) <> Тип("Запрос") Тогда
		Возврат "!Не верный тип параметра 2: " + ТипЗнч(Запрос) + ". Должен быть тип ""Запрос""";
	КонецЕсли;
	
	Инициализация(, чСеансИД);
	
	стрИмяФайла = ПолучитьИмяВременногоФайла(РасширениеЗахваченныхЗапросов);
	
	ВременныеТаблицы = Новый Массив;
	
	Если Запрос.МенеджерВременныхТаблиц <> Неопределено Тогда
		Для Каждого Таблица Из Запрос.МенеджерВременныхТаблиц.Таблицы Цикл
			
			ВременнаяТаблица = Новый ТаблицаЗначений;
			Для Каждого Колонка Из Таблица.Колонки Цикл
				ВременнаяТаблица.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
			КонецЦикла;
			
			выбТаблица = Таблица.ПолучитьДанные().Выбрать();
			Пока выбТаблица.Следующий() Цикл
				ЗаполнитьЗначенияСвойств(ВременнаяТаблица.Добавить(), выбТаблица);
			КонецЦикла;
			
			ВременныеТаблицы.Добавить(
				Новый Структура("Имя, Таблица", Таблица.ПолноеИмя, ВременнаяТаблица)
			);
		КонецЦикла;
	КонецЕсли;
	
	Структура = Новый Структура("Текст, Параметры, ВременныеТаблицы", , , ВременныеТаблицы);
	ЗаполнитьЗначенияСвойств(Структура, Запрос);
	
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(стрИмяФайла);
	СериализаторXDTO.ЗаписатьXML(ЗаписьXML, Структура, НазначениеТипаXML.Явное);
	
	ЗаписьXML.Закрыть();
	
	Возврат "ОК:";// + стрИмяФайла;
	
КонецФункции

//&НаСервереБезКонтекста
Функция ВыполнитьКод(ЭтотКод, Выборка, Параметры, ПризнакПрогресса)
	Выполнить(ЭтотКод);	
КонецФункции

//Этот метод можно использовать в коде для отображения прогресса.
//Параметры:
//	Обработано - число, количество обработанных записей.
//	КоличествоВсего - число, количество записей в выборке всего.
//	ДатаНачалаВМиллисекундах - число, дата начала обработки, полученное с помощью ТекущаяУниверсальнаяДатаВМиллисекундах()
//		в момент начала обработки. Это значение необходимо корректного расчета оставшегося времени.
//	ПризнакПрогресса - строка, специальное значение, необходимое для передачи значений прогресса на клиент.
//		Это значение необходимо просто передать в параметр без изменений.
Функция СообщитьПрогресс(Обработано, КоличествоВсего, ДатаНачалаВМиллисекундах, ПризнакПрогресса)
	ДатаВМиллисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах();
	Сообщить(ПризнакПрогресса + ЗначениеВСтроку(Новый Структура("Прогресс, ДлительностьНаМоментПрогресса", Обработано * 100 / КоличествоВсего, ДатаВМиллисекундах - ДатаНачалаВМиллисекундах)));
	Возврат ДатаВМиллисекундах;
КонецФункции

Процедура ВыполнитьАлгоритмПользователя(ПараметрыВыполнения, АдресРезультата) Экспорт

	стРезультатЗапроса = ПараметрыВыполнения[0];
	маРезультатЗапроса = стРезультатЗапроса.Результат;
	ПараметрыЗапроса = стРезультатЗапроса.Параметры;
	РезультатВПакете = ПараметрыВыполнения[1];
	Код = ПараметрыВыполнения[2];
	фПострочно = ПараметрыВыполнения[3];
	ИнтервалОбновленияВыполненияАлгоритма = ПараметрыВыполнения[4];
	
	стРезультат = маРезультатЗапроса[Число(РезультатВПакете) - 1];
	рзВыборка = стРезультат.Результат;
	Выборка = рзВыборка.Выбрать();
	ДатаНачалаВМиллисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	Если фПострочно Тогда
		
		КоличествоВсего = Выборка.Количество();
		чМоментОкончанияПорции = 0;
		й = 0;
		Пока Выборка.Следующий() Цикл
			
			ВыполнитьКод(Код, Выборка, ПараметрыЗапроса, АдресРезультата);
			
			й = й + 1;
			Если ТекущаяУниверсальнаяДатаВМиллисекундах() >= чМоментОкончанияПорции Тогда
				//Будем использовать АдресРезультата в качестве метки сообщения состояния - это очень уникальное значение.
				ДатаВМиллисекундах = СообщитьПрогресс(й, КоличествоВсего, ДатаНачалаВМиллисекундах, АдресРезультата);
				чМоментОкончанияПорции = ДатаВМиллисекундах + ИнтервалОбновленияВыполненияАлгоритма;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		ВыполнитьКод(Код, Выборка, ПараметрыЗапроса, АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры
