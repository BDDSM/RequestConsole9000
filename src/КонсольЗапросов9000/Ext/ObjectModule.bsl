﻿// Консоль запросов 9000 v 1.1.9
// (C) Александр Кузнецов 2019-2020
// hal@hal9000.cc
//Минимальная версия платформы 8.3.12, минимальный режим совместимости 8.3.8

Процедура Инициализация(Форма = Неопределено, чСеансИД = Неопределено) Экспорт
	
	ВерсияОбработки = "1.1.9";
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

Функция ПолучитьКартинкуПоТипу(ТипЗначения, КартинкиСтруктура = Неопределено) Экспорт
	
	стрИмяКартинки = Неопределено;
	Если ТипЗнч(ТипЗначения) = Тип("ОписаниеТипов") Тогда
		
		маТипы = ТипЗначения.Типы();
		
		стрИмяКартинки = Неопределено;
		Для Каждого Тип Из маТипы Цикл
			стрИмяКартинкиТипа = ПолучитьИмяКартинкиТипа(Тип);
			Если стрИмяКартинки = Неопределено Тогда
				стрИмяКартинки = стрИмяКартинкиТипа;
			ИначеЕсли стрИмяКартинки <> стрИмяКартинкиТипа Тогда
				стрИмяКартинки = "Тип_Неопределено";
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(ТипЗначения) = Тип("Строка") Тогда
		стрИмяКартинки = ПолучитьИмяКартинкиТипа(ТипЗначения);
	КонецЕсли;
	
	Если КартинкиСтруктура = Неопределено Тогда
		КартинкиСтруктура = ПолучитьИзВременногоХранилища(Картинки);
	КонецЕсли;
	
	Если стрИмяКартинки = Неопределено Тогда
		стрИмяКартинки = "Тип_Реопределено";
	КонецЕсли;
	
	Картинка = Неопределено;
	КартинкиСтруктура.Свойство(стрИмяКартинки, Картинка);
	Возврат Картинка;
	
КонецФункции

Функция ТипБезПустых(ОписаниеТипов) Экспорт
	
	Если ТипЗнч(ОписаниеТипов) <> Тип("ОписаниеТипов") Тогда
		Возврат ОписаниеТипов;
	КонецЕсли;
	
	маПустыеТипы = Новый Массив;
	маПустыеТипы.Добавить(Тип("Null"));
	маПустыеТипы.Добавить(Тип("Неопределено"));
	
	Возврат Новый ОписаниеТипов(ОписаниеТипов, , маПустыеТипы);
	
КонецФункции
			
//Значение - это тп, либо строка. То есть то, что содержиться в поле ТипЗначения таблицы параметров.
Функция ПолучитьИмяКартинкиТипа(Значение) Экспорт
	
	Если Значение = "Таблица значений" Тогда
		Возврат "Тип_ТаблицаЗначений";
	ИначеЕсли Значение = Тип("Массив") Тогда
		Возврат "Тип_Массив";
	ИначеЕсли Значение = Тип("СписокЗначений") Тогда
		Возврат "Тип_СписокЗначений";
	ИначеЕсли Значение = Тип("Строка") Тогда
		Возврат "Тип_Строка";
	ИначеЕсли Значение = Тип("Число") Тогда
		Возврат "Тип_Число";
	ИначеЕсли Значение = Тип("Булево") Тогда
		Возврат "Тип_Булево";
	ИначеЕсли Значение = Тип("Дата") Тогда
		Возврат "Тип_Дата";
	ИначеЕсли Значение = Тип("Граница") Тогда
		Возврат "Тип_Граница";
	ИначеЕсли Значение = Тип("МоментВремени") Тогда
		Возврат "Тип_МоментВремени";
	ИначеЕсли Значение = Тип("Тип") Тогда
		Возврат "Тип_Тип";
	ИначеЕсли Значение = Тип("УникальныйИдентификатор") Тогда
		Возврат "Тип_УникальныйИдентификатор";
	ИначеЕсли Значение = Тип("Неопределено") Тогда
		Возврат "Тип_Неопределено";
	ИначеЕсли Справочники.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_СправочникСсылка";;
	ИначеЕсли Документы.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_ДокументСсылка";
	ИначеЕсли Перечисления.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_ПеречислениеСсылка";
	ИначеЕсли ПланыВидовХарактеристик.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_ПланВидовХарактеристикСсылка";
	ИначеЕсли ПланыСчетов.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_ПланСчетовСсылка";
	ИначеЕсли ПланыВидовРасчета.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_ПланВидовРасчетаСсылка";
	ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_БизнесПроцессСсылка";
	ИначеЕсли Задачи.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_ЗадачаСсылка";
	ИначеЕсли ПланыОбмена.ТипВсеСсылки().СодержитТип(Значение) Тогда
		Возврат "Тип_ПланОбменаСсылка";
	ИначеЕсли Значение = Тип("Null") Тогда
		Возврат "Тип_Null";
	ИначеЕсли Значение = Тип("ВидДвиженияБухгалтерии") Тогда
		Возврат "Тип_ВидДвиженияБухгалтерии";
	ИначеЕсли Значение = Тип("ВидДвиженияНакопления") Тогда
		Возврат "Тип_ВидДвиженияНакопления";
	ИначеЕсли Значение = Тип("ВидСчета") Тогда
		Возврат "Тип_ВидСчета";
	Иначе
		Возврат "Тип_Неопределено";
	КонецЕсли;
	
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

#Область ТехнологическийЖурнал

&НаСервере
Функция ТехнологическийЖурнал_ПолучитьКаталогКонфигурацииПриложения()
	
	//СистемнаяИнформация = Новый СистемнаяИнформация();
	//Если НЕ ((СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86) Или (СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Windows_x86_64)) Тогда
	//	Возврат Неопределено;
	//КонецЕсли;
	
	КаталогаОбщихКонфигурационныхФайлов = КаталогПрограммы() + "conf";
	ФайлУказатель = Новый Файл(КаталогаОбщихКонфигурационныхФайлов + ПолучитьРазделительПутиСервера() + "conf.cfg");
	Если ФайлУказатель.Существует() Тогда
		ФайлКонфигурации = Новый ЧтениеТекста(ФайлУказатель.ПолноеИмя);
		Строка = ФайлКонфигурации.ПрочитатьСтроку();
		Пока Строка <> Неопределено Цикл
			Позиция = СтрНайти(Строка, "ConfLocation=");
			Если Позиция > 0 Тогда 
				КаталогКонфигурацииПриложения = СокрЛП(Сред(Строка, Позиция + 13));
				Прервать;
			КонецЕсли;
			Строка = ФайлКонфигурации.ПрочитатьСтроку();
		КонецЦикла;
	КонецЕсли;
	
	Возврат КаталогКонфигурацииПриложения;
	
КонецФункции

Функция ТехнологическийЖурнал_МеткаКонсоли()
	Возврат СтрШаблон("КонсольЗапросов9000_%1", Формат(СеансИД, "ЧГ=0"));
КонецФункции

&НаСервере
Функция ТехнологическийЖурнал_ЭтоДОМКонфигурацииТЖ(Документ) Экспорт
	Возврат Документ.ПервыйДочерний.URIПространстваИмен = "http://v8.1c.ru/v8/tech-log" И Документ.ПервыйДочерний.ИмяУзла = "config";
КонецФункции

&НаСервере
Функция ТехнологическийЖурнал_УдалитьЛогКонсолиИзДОМ(Документ) Экспорт
	
	стрМетка = ТехнологическийЖурнал_МеткаКонсоли();
	
	маУзлыДляУдаления = Новый Массив;
	
	фРежимУдаления = Ложь;
	Для Каждого Узел Из Документ.ПервыйДочерний.ДочерниеУзлы Цикл
		
		Если Узел.ИмяУзла = "#comment" И СокрЛП(Узел.ЗначениеУзла) = стрМетка Тогда
			
			Если фРежимУдаления Тогда
				маУзлыДляУдаления.Добавить(Узел);
				фРежимУдаления = Ложь;
			Иначе
				фРежимУдаления = Истина;
			КонецЕсли;
			
		КонецЕсли;
		
		Если фРежимУдаления Тогда
			маУзлыДляУдаления.Добавить(Узел);
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Узел Из маУзлыДляУдаления Цикл
		Документ.ПервыйДочерний.УдалитьДочерний(Узел);
	КонецЦикла;
	
	Возврат маУзлыДляУдаления.Количество() > 0;
	
КонецФункции

&НаСервере
Процедура ТехнологическийЖурнал_ЗаписатьДОМ(Документ, ИмяФайла) Экспорт
	
	Записыватель = Новый ЗаписьDOM;

	ВременныйФайл = ИмяФайла + ".tmp";
	
	Запись = Новый ЗаписьXML;
	Запись.ОткрытьФайл(ВременныйФайл);
	Записыватель.Записать(Документ, Запись);
	Запись.Закрыть();
			
	ПереместитьФайл(ВременныйФайл, ИмяФайла);
	
КонецПроцедуры

&НаСервере
Функция ТехнологическийЖурнал_ЕстьЛогКонсоли() Экспорт
	
	ФайлКонфигурацииТЖ = ТехнологическийЖурнал_ПолучитьКаталогКонфигурацииПриложения() + ПолучитьРазделительПутиСервера() + "logcfg.xml";
	ФайлКонфигурации = Новый Файл(ФайлКонфигурацииТЖ);
	
	Если ФайлКонфигурации.Существует() Тогда
		
		Документ = ТехнологическийЖурнал_ПрочитатьДОМ(ФайлКонфигурацииТЖ);
		
		Если ТехнологическийЖурнал_ЭтоДОМКонфигурацииТЖ(Документ) Тогда
			
			стрМетка = ТехнологическийЖурнал_МеткаКонсоли();
			фЕстьМетка = Ложь;
			Для Каждого Узел Из Документ.ПервыйДочерний.ДочерниеУзлы Цикл
				
				Если фЕстьМетка Тогда
					АтрибутРазмещенияЖурнала = Узел.Атрибуты.ПолучитьИменованныйЭлемент("location");
					Если АтрибутРазмещенияЖурнала <> Неопределено Тогда
						КаталогТехнологическогоЖурнала = АтрибутРазмещенияЖурнала.Значение;
						Возврат Истина;
					КонецЕсли;
				КонецЕсли;
				
				Если Узел.ИмяУзла = "#comment" И СокрЛП(Узел.ЗначениеУзла) = стрМетка Тогда
					фЕстьМетка = Истина;
				КонецЕсли;
				
			КонецЦикла;
					
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
		
&НаСервере
Процедура ТехнологическийЖурнал_ДобавитьЛогКонсоли(ПутьТЖ) Экспорт
	
	ФайлКонфигурацииТЖ = ТехнологическийЖурнал_ПолучитьКаталогКонфигурацииПриложения() + ПолучитьРазделительПутиСервера() + "logcfg.xml";
	ФайлКонфигурации = Новый Файл(ФайлКонфигурацииТЖ);
	
	Если ФайлКонфигурации.Существует() Тогда
		
		Документ = ТехнологическийЖурнал_ПрочитатьДОМ(ФайлКонфигурацииТЖ);
		
		Если ТехнологическийЖурнал_ЭтоДОМКонфигурацииТЖ(Документ) Тогда
			
			ТехнологическийЖурнал_УдалитьЛогКонсолиИзДОМ(Документ);
			
			МакетКонфигурацииТЖ = ПолучитьМакет("МакетКонфигурацииТЖ");
			Чтение = Новый ЧтениеXML;
			стрФильтрКонтекста = "%.КонсольЗапросов9000.%";
			Чтение.УстановитьСтроку(СтрШаблон(МакетКонфигурацииТЖ.ПолучитьТекст(), ТехнологическийЖурнал_МеткаКонсоли(),
			                                                             ПутьТЖ, НомерСеансаИнформационнойБазы(), стрФильтрКонтекста));
		    Построитель = Новый ПостроительDOM;
			logcfg = Построитель.Прочитать(Чтение);
			
			Для Каждого ИсходныйУзел Из logcfg.ПервыйДочерний.ДочерниеУзлы Цикл
				Узел = Документ.ИмпортироватьУзел(ИсходныйУзел, Истина);
				Документ.ПервыйДочерний.ДобавитьДочерний(Узел);
			КонецЦикла;
			
			ТехнологическийЖурнал_ЗаписатьДОМ(Документ, ФайлКонфигурацииТЖ);
			КаталогТехнологическогоЖурнала = ПутьТЖ;
			
		КонецЕсли;
		
	Иначе
		ВызватьИсключение "logcfg не найден";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТехнологическийЖурнал_ПрочитатьДОМ(ИмяФайла) Экспорт
	Чтение = Новый ЧтениеXML;
    Чтение.ОткрытьФайл(ИмяФайла);
    Построитель = Новый ПостроительDOM;
    Возврат Построитель.Прочитать(Чтение);
КонецФункции

&НаСервере
Процедура ТехнологическийЖурнал_УдалитьЛогКонсоли() Экспорт
	
	ФайлКонфигурацииТЖ = ТехнологическийЖурнал_ПолучитьКаталогКонфигурацииПриложения() + ПолучитьРазделительПутиСервера() + "logcfg.xml";
	ФайлКонфигурации = Новый Файл(ФайлКонфигурацииТЖ);
	
	Если ФайлКонфигурации.Существует() Тогда
		
		Документ = ТехнологическийЖурнал_ПрочитатьДОМ(ФайлКонфигурацииТЖ);
		
		Если ТехнологическийЖурнал_ЭтоДОМКонфигурацииТЖ(Документ) Тогда
			
			ТехнологическийЖурнал_УдалитьЛогКонсолиИзДОМ(Документ);
			
			ТехнологическийЖурнал_ЗаписатьДОМ(Документ, ФайлКонфигурацииТЖ);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТехнологическийЖурнал_Включился() Экспорт
	маФайлы = НайтиФайлы(КаталогТехнологическогоЖурнала, "rphost*");
	ТехнологическийЖурналВключен = маФайлы.Количество() > 0;
	Возврат ТехнологическийЖурналВключен;
КонецФункции

&НаСервере
Функция ТехнологическийЖурнал_Выключился() Экспорт
	
	Попытка
		УдалитьФайлы(КаталогТехнологическогоЖурнала);
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	ТехнологическийЖурналВключен = Ложь;
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ТехнологическийЖурнал_Включить() Экспорт
	
	ПутьТЖ = КаталогВременныхФайлов() + РасширениеЗахваченныхЗапросов;
	
	й = 1;
	Пока Истина Цикл
		
		Файл = Новый Файл(ПутьТЖ);
		
		Если Файл.Существует() Тогда
			Попытка
				УдалитьФайлы(Файл.ПолноеИмя);
			Исключение
			КонецПопытки;
		КонецЕсли;
		
		Если НЕ Файл.Существует() Тогда
			Прервать;
		КонецЕсли;
		
		//Не удается удалить каталог. Возможно, ТЖ еще не выключен.
		//Придется использовать другой, иначе будет невозможно контролировать включение.
		//Текущий каталог с логами очиститься при следующем "нормальном" включении.
		ПутьТЖ = КаталогВременныхФайлов() + РасширениеЗахваченныхЗапросов + й;
		й = й + 1;
		
	КонецЦикла;
	
	ТехнологическийЖурнал_ДобавитьЛогКонсоли(ПутьТЖ);
	
КонецПроцедуры

&НаСервере
Процедура ТехнологическийЖурнал_Выключить() Экспорт
	ТехнологическийЖурнал_УдалитьЛогКонсоли();
КонецПроцедуры

#КонецОбласти

#Область СохраняемыеСостояния

//Сохраняемые состояния - структура, предназначена для сохранения значений, которых нет в опциях (состояния флажков форм,
//разных значений, и т.д.). Записывается в файл. Из файла читается только при первом открытии.

Процедура СохраняемыеСостояния_Сохранить(ИмяЗначения, Значение) Экспорт
	СохраняемыеСостояния.Вставить(ИмяЗначения, Значение);
КонецПроцедуры

Функция СохраняемыеСостояния_Получить(ИмяЗначения, ЗначениеПоУмолчанию) Экспорт
	Перем Значение;
	
	Если НЕ СохраняемыеСостояния.Свойство(ИмяЗначения, Значение) Тогда
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
