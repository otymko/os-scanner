Функция СодержимоеФайла(Знач ПутьКФайлу) Экспорт

	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Прочитать(ПутьКФайлу, КодировкаТекста.UTF8);
	Возврат ТекстовыйДокумент.ПолучитьТекст();

КонецФункции