Процедура МояПроцедура()
    ЗавершитьРаботуСистемы(); // не ошибка
КонецПроцедуры

Функция МояПроцедура()
    ПрекратитьРаботуСистемы(); // не ошибка
КонецФункции

Процедура МояПроцедура()
    Если Условие Тогда
        ПолучитьCOMОбъект("C:\DATA\DATA.doc");
    КонецЕсли;
КонецПроцедуры

ЗапуститьПриложение("Таблица.xls");

НачатьЗапускПриложения(Оповещение,,, Истина);

КомандаСистемы("start iexplore.exe http://helpme1c.ru");

ПолучитьCOMОбъект("C:\DATA\DATA.doc");

ЗапуститьСистему("C:\Program Files (x86)\1cv8\8.3.2.163\bin\1cv8.exe ENTERPRISE /F C:\Users\username\Documents\1C\Platform82Demo /N Администратор /TESTCLIENT");

ПрекратитьРаботуСистемы(); // не ошибка
 
ЗавершитьРаботуСистемы(); // не ошибка
