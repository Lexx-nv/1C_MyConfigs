﻿//Функция ЗаполнитьПереченьПодразделений() Экспорт
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	уатМестонахождениеТССрезПоследних.Подразделение КАК Подразделение,
//		|	уатМестонахождениеТССрезПоследних.Подразделение.Наименование КАК Наименование,
//		|	СУММА(1) КАК Количество
//		|ИЗ
//		|	РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаЗапроса, ) КАК уатМестонахождениеТССрезПоследних
//		|ГДЕ
//		|	уатМестонахождениеТССрезПоследних.Состояние.ЗапретитьВыпискуПЛ = ЛОЖЬ
//		|	И уатМестонахождениеТССрезПоследних.Состояние <> ЗНАЧЕНИЕ(Справочник.уатСостояниеТС.Привлеченный)
//		|	И уатМестонахождениеТССрезПоследних.Подразделение <> ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	уатМестонахождениеТССрезПоследних.Подразделение
//		|
//		|УПОРЯДОЧИТЬ ПО
//		|	Подразделение
//		|АВТОУПОРЯДОЧИВАНИЕ";
//	
//	Запрос.УстановитьПараметр("ДатаЗапроса", ТекущаяДата());
//	
//	//РезультатЗапроса = Запрос.Выполнить();
//	
//	//Выборка = РезультатЗапроса.Выбрать();
//	
//	//Пока Выборка.Следующий() Цикл
//	//	Элементы.Подразделение.СписокВыбора.Добавить(Выборка.Подразделение);
//	//КонецЦикла;
//	
//	Возврат Запрос.Выполнить().Выгрузить();
//	//ПереченьПодразделений.Загрузить(Запрос.Выполнить().Выгрузить());

//КонецФункции


Процедура СформироватьФайлДанных_АвтоГРАФ5() Экспорт
	//СистемаМониторинга = Справочники.СистемыМониторинга.НайтиПоРеквизиту("ФлагПриоритетнаяСистема",Истина);
	//ТекстОшибки			 = "";
	//ТекстJSON = "";
	//ДанныеЗапроса = Неопределено;
	//ВнешняяСистема	 = СистемаМониторинга.ВидСистемыGPS;
	//УчетнаяЗапись	 = СистемаМониторинга;
	//Если ВнешняяСистема = Перечисления.ВидСистемыGPS.Автограф Тогда
	//	КодВозврата = глСистемыМониторингаСервер.АвтоГРАФ5_GetOnlineInfoAll(УчетнаяЗапись, ДанныеЗапроса, ТекстОшибки, ТекстJSON);
	//	Если КодВозврата = 0 И ТекстОшибки = "" Тогда
	//		Текст = Новый ЗаписьТекста("E:\Work\out.txt");
	//		Текст.Записать(ТекстJSON);
	//		Текст.Закрыть();			
	//	КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

Функция СткПолучитьСоединение() Экспорт
	Стк = Новый Структура();
	Стк.Вставить("Сервер",СокрЛП(Константы.АдресСервераПЛ.Получить()));
	Стк.Вставить("Порт",80);
	Стк.Вставить("Логин","1с_Рег_Работы");
	Стк.Вставить("Пароль","19621209091262");
	Возврат Стк;
КонецФункции

Функция ПолучитьОсновныеТаблицы() Экспорт
	СткСоединение = СткПолучитьСоединение();
	АдресБазы = Константы.НаименованиеБазыПЛ.Получить();
	
	Соединение = Новый HTTPСоединение(
									СткСоединение.Сервер, // сервер (хост)
									СткСоединение.Порт, // порт, по умолчанию для http используется 80, для https 443
									СткСоединение.Логин, // пользователь для доступа к серверу (если он есть)
									СткСоединение.Пароль, // пароль для доступа к серверу (если он есть)
									, // здесь указывается прокси, если он есть
									, // таймаут в секундах, 0 или пусто - не устанавливать
									// защищенное соединение, если используется https
									);
									
	Запрос = Новый HTTPЗапрос("/"+АдресБазы+"/hs/entAPI/DATAOKO");
	Ответ = Соединение.Получить(Запрос);
	Результат = Ответ.ПолучитьТелоКакСтроку();
	
	
	Если Ответ.КодСостояния <> 200 ТОгда
		Возврат ("Ошибка код: "+Результат.КодСостояния);
	КонецеСЛИ;
	
	ХЗ = XMLзначение(Тип("ХранилищеЗначения"),Результат);
	Стк = ХЗ.получить();
	
	Возврат Стк;
КонецФункции	