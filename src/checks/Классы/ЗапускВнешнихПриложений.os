Перем ИмяПроверки Экспорт;
Перем ТекстОшибки;

Перем МетодыТригеры;

Перем ТаблицаОшибок;
Перем Типы;
Перем Результат;

Процедура ПриСозданииОбъекта()
	ИмяПроверки = "CallingExternalApplication";
	ТекстОшибки = "Запуск внешнего приложения может быть небезопасен";
	
	МетодыТригеры = Новый Массив;
	МетодыТригеры.Добавить("ЗАПУСТИТЬПРИЛОЖЕНИЕ");
	МетодыТригеры.Добавить("RUNAPP");
	МетодыТригеры.Добавить("НАЧАТЬЗАПУСКПРИЛОЖЕНИЯ");
	МетодыТригеры.Добавить("BEGINRUNNINGAPPLICATION");
	МетодыТригеры.Добавить("КОМАНДАСИСТЕМЫ");
	МетодыТригеры.Добавить("SYSTEM");
	МетодыТригеры.Добавить("ПОЛУЧИТЬCOMОБЪЕКТ");
	МетодыТригеры.Добавить("GETCOMOBJECT");
	МетодыТригеры.Добавить("ЗАПУСТИТЬСИСТЕМУ");
	МетодыТригеры.Добавить("RUNSYSTEM");
КонецПроцедуры

Процедура Открыть(Парсер, Параметры) Экспорт
	Типы = Парсер.Типы();
	Результат = Новый Массив;
	ТаблицаОшибок = Парсер.ТаблицаОшибок();
КонецПроцедуры

Функция Закрыть() Экспорт
	Возврат СтрСоединить(Результат);
КонецФункции

Функция Подписки() Экспорт
	Подписки = Новый Массив;
	Подписки.Добавить("ПосетитьВыражениеИдентификатор");
	Возврат Подписки;
КонецФункции

Процедура ПосетитьВыражениеИдентификатор(ВыражениеИдентификатор) Экспорт
	
	Метод = ВРег(ВыражениеИдентификатор.Голова.Имя);
	Если Не МетодыТригеры.Найти(Метод) = Неопределено Тогда
		Ошибка(ТекстОшибки, ВыражениеИдентификатор.Начало, ВыражениеИдентификатор.Конец);
	КонецЕсли;
	
КонецПроцедуры

Процедура Ошибка(Текст, Начало, Конец = Неопределено, ЕстьЗамена = Ложь)
	Ошибка = ТаблицаОшибок.Добавить();
	Ошибка.Источник = ИмяПроверки;
	Ошибка.Текст = Текст;
	Ошибка.ПозицияНачала = Начало.Позиция;
	Ошибка.НомерСтрокиНачала = Начало.НомерСтроки;
	Ошибка.НомерКолонкиНачала = Начало.НомерКолонки;
	Если Конец = Неопределено Или Конец = Начало Тогда
		Ошибка.ПозицияКонца = Начало.Позиция + Начало.Длина;
		Ошибка.НомерСтрокиКонца = Начало.НомерСтроки;
		Ошибка.НомерКолонкиКонца = Начало.НомерКолонки + Начало.Длина;
	Иначе
		Ошибка.ПозицияКонца = Конец.Позиция + Конец.Длина;
		Ошибка.НомерСтрокиКонца = Конец.НомерСтроки;
		Ошибка.НомерКолонкиКонца = Конец.НомерКолонки + Конец.Длина;
	КонецЕсли;
	Ошибка.ЕстьЗамена = ЕстьЗамена;
КонецПроцедуры