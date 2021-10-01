﻿
				
Функция ЗаписатьХранилищеВСтроку(Тбл,ТекДт=Неопределено)
	
	Если ТекДт = Неопределено Тогда
		ТекДТ = ТекущаяДата();
	КонецЕСЛИ;
	
	Стк = Новый структура();
	Для а=1 по ТБл.Колонки.Количество() Цикл
		Кол = ТБл.Колонки[а-1];
		
		Если Найти(Кол.Имя,"GUID") <> 0 Тогда
			п = Кол.Имя;
			Кол.Имя = п+"1";
			ТБл.Колонки.Добавить(п,Новый ОписаниеТипов("Строка"));
			Стк.Вставить(п+"1",п);
		КонецЕСЛИ;
		
	КонеццИклА;
	
	Если Стк.Количество()<>0 Тогда
		Для каждого Стр из ТБл Цикл
			Для каждого эл из Стк Цикл
				Стр[эл.Значение] = СокрЛП(Стр[эл.Ключ].УникальныйИдентификатор());
			Конеццикла;
		КонецЦикла;
	КонецЕсли;
	
	//Удалим лишние колонки
	Для каждого Эл из Стк Цикл
		Тбл.Колонки.Удалить(Эл.Ключ);
	КонецЦикла;
	
	Мас = Новый МАссив;
	Мас.Добавить(ТекДТ);
	МАс.ДОбавить(ТБл);
	
	хр = Новый ХранилищеЗначения(Мас,Новый СжатиеДанных(5));
	Возврат XMLСтрока(хр);
	
КонецФункции
			 
Функция УстановитьКонстантуПроектОКО(Тело,КодСостояния)
	
	Зн = XMLЗначение(Тип("ХранилищеЗначения"),Тело).Получить();
	//Если ТипЗнч(зн)<>Тип("УникальныйИдентификатор") ТОгда
	//	КодСостояния = 409;
	//	Возврат "Неверный тип значения";
	//КонецеСЛИ;
	
	ЗаписьЖурналаРегистрации("Информация",,,,Зн);
	
	Константы.окоЗначениеДляФормыЭкрана.Установить(зн);
	Возврат "Ok. "+зн;
	
КонецФункции

Функция GETGET(Запрос)
	
	начДтАПИ = ТекущаяДата();
	
	
	Ответ = Новый HTTPСервисОтвет(200);
	Метод = ВРЕГ(Запрос.ПараметрыURL["ИмяМетода"]);
	
	СткПар = Новый Структура;
	Для каждого Эл из Запрос.ПараметрыЗапроса Цикл
		СткПар.Вставить(Эл.Ключ,Эл.Значение);	
	КонецЦикла;
	
	Если Метод = "OKOCONSTPODR" Тогда
		Результат = УстановитьКонстантуПроектОКО(Запрос.ПолучитьТелоКакСтроку(), Ответ.КодСостояния);
	ИНаче
		Запрос.КодСостояния = 304;
		Результат = "Метод "+Метод+" не обнаружен";
	КонецеСли;
	
	Ответ.УстановитьТелоИзСтроки(Результат);
	
	Возврат Ответ;
КонецФункции
