#Использовать osparser
#Использовать json
#Использовать progbar
#Использовать "../../checks"

Перем ИдентификаторСенсора;

Перем РабочийКаталог;
Перем ФайловаяСистема;
Перем ОбщаяТаблицаОшибок;

Перем Парсер;
Перем Проверки;

Перем ПрогрессБар;

Процедура ПриСозданииОбъекта(Знач пРабочийКаталог)

	ИдентификаторСенсора = "bsl-freeos";

	РабочийКаталог = пРабочийКаталог;
	ФайловаяСистема = Новый ФайловаяСистема(РабочийКаталог);
	
	Парсер = Новый ПарсерВстроенногоЯзыка;
	Проверки = Новый Массив;
	ОбщаяТаблицаОшибок = НоваяТаблицаОшибок();

КонецПроцедуры

Процедура Инициализировать() Экспорт
	КлассыПроверок = НайтиКлассыПроверок();
	Для Каждого Проверка Из КлассыПроверок Цикл
		Проверки.Добавить(Проверка);
	КонецЦикла;
	Сообщить("Доступно проверок: " + Проверки.Количество());
	ПрогрессБар = Новый ПрогрессБар();
КонецПроцедуры

Процедура Запустить() Экспорт
	
	Фильтр = Новый Структура("Расширение", "bsl");
	ВходящиеФайлы = ФайловаяСистема.ВходящиеФайлы(Фильтр);
	
	Счетчик = 1;
	ОбщееКоличество = ВходящиеФайлы.Количество();

	ПрогрессБар.Начать(ОбщееКоличество, "Анализ файлов");

	Для Каждого ВходящийФайл Из ВходящиеФайлы Цикл
		ПрогрессБар.СделатьШаг();
		
		Попытка
			Парсер.Пуск(Вспомогательный.СодержимоеФайла(ВходящийФайл.ПолноеИмя), Проверки);
		Исключение
			Сообщить("Не удалось обработать файл: " + ВходящийФайл.ПолноеИмя + ". Причина" + ОписаниеОшибки());
		КонецПопытки;

		Отчет = Новый Массив;
		Для Каждого Ошибка Из Парсер.ТаблицаОшибок() Цикл
			НоваяОшибка = ОбщаяТаблицаОшибок.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяОшибка, Ошибка);
			НоваяОшибка.Файл = ВходящийФайл.ПолноеИмя;
		КонецЦикла;

		Счетчик = Счетчик + 1;
	КонецЦикла;
	
КонецПроцедуры

Функция РезультатАнализа() Экспорт
	
	Возврат Новый Структура();
	
КонецФункции

Процедура Сохранить(ПутьКФайлу) Экспорт
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, "",,,,,,, Истина);

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписатьJSON(ЗаписьJSON, ОтчетИзТаблицы(ОбщаяТаблицаОшибок));
	Текст = ЗаписьJSON.Закрыть();
	
	ЗаписатьФайл(ПутьКФайлу, Текст);
КонецПроцедуры

Процедура ЗаписатьФайл(Знач ПутьКФайлу, Знач ТекстФайла) Экспорт

	ЗаписьТекста = Новый ЗаписьТекста(ПутьКФайлу);
	ЗаписьТекста.Записать(ТекстФайла);
	ЗаписьТекста.Закрыть();

КонецПроцедуры

Функция ОтчетИзТаблицы(ВходящиеДанные)

	Отчет = Новый Структура;
	Отчет.Вставить("issues", Новый Массив);

	Для Каждого Данные Из ВходящиеДанные Цикл

		Местоположение = Новый Структура;
		Местоположение.Вставить("message", Данные.Текст);
		Местоположение.Вставить("filePath", Данные.Файл);
		Местоположение.Вставить("textRange", Новый Структура);
		Местоположение.textRange.Вставить("startLine", Данные.НомерСтрокиНачала);
		Местоположение.textRange.Вставить("endLine", Данные.НомерСтрокиКонца);
		Местоположение.textRange.Вставить("startColumn", Данные.НомерКолонкиНачала - 1);
		Местоположение.textRange.Вставить("endColumn", Данные.НомерКолонкиКонца  - 1);
		
		Замечание = Новый Структура;
		Замечание.Вставить("engineId", ИдентификаторСенсора);
		Замечание.Вставить("ruleId", Данные.Источник);
		Замечание.Вставить("type", "BUG"); // TODO: брать из проверки
		Замечание.Вставить("severity", "CRITICAL"); // TODO: брать из проверки
		Замечание.Вставить("primaryLocation", Местоположение);
		Замечание.Вставить("effortMinutes", Данные.МинутНаИсправление);
		
		Отчет.issues.Добавить(Замечание);

	КонецЦикла;

	Возврат Отчет;

КонецФункции

Функция НоваяТаблицаОшибок() 
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Файл", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("Источник", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("Код", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("Текст", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ПозицияНачала", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("НомерСтрокиНачала", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("НомерКолонкиНачала", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ПозицияКонца", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("НомерСтрокиКонца", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("НомерКолонкиКонца", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("ЕстьЗамена", Новый ОписаниеТипов("Булево"));
	Таблица.Колонки.Добавить("МинутНаИсправление", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("Серьезность", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("Правило", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("Тип", Новый ОписаниеТипов("Строка"));
	Возврат Таблица;
КонецФункции

Функция НайтиКлассыПроверок()
	Список = Новый Массив;
	КаталогПрограммы = ОбъединитьПути(ТекущийСценарий().Каталог, "..", "..");
	КаталогПоиска = ОбъединитьПути(КаталогПрограммы, "checks", "Классы");
	Файлы = НайтИФайлы(КаталогПоиска, "*.os", Истина);
	Для Каждого Файл Из Файлы Цикл
		Проверка = ЗагрузитьСценарий(Файл.ПолноеИмя);
		Список.Добавить(Проверка);
	КонецЦикла;
	Возврат Список;
КонецФункции