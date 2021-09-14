﻿
&НаКлиенте
Процедура ИнформационнаяБазаПриИзменении(Элемент)
	ЗаполнитьПользователей();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПользователей()
	Если ЗначениеЗаполнено(Объект.ИнформационнаяБаза) Тогда
		ТекстОшибки = "";

		//Получим из регистра уже исключенных пользователей
		ТблИскл = ОбщегоНазначения.ПолучитьИсключенныхПользователей(Объект.ИнформационнаяБаза);
		Объект.ИсключаемыеПользователи.Загрузить(ТблИскл);
		
		//Получим таблицу работающих сотрудников
		Тбл = ОбщегоНазначения.ПолучитьРаботающих(Объект.ИнформационнаяБаза,ТекстОшибки);
		Если Тбл = 1 Тогда //Какой-то  косяк с получением данных из ЗУП
			Сообщить(ТекстОшибки);
		КонецЕсли;	
		ТБл.Свернуть("ФИО");
		Для Каждого ХХХ Из Тбл Цикл
			ХХХ.ФИО = ВРег(СтрЗаменить(ХХХ.ФИО," ","")); 
		КонецЦикла;	
		
		//Получим массив пользователей информационной базы
		Объект.ПользователиИБ.Очистить();
		Мас = ОбщегоНазначения.ПолучитьПользователейИБ(Объект.ИнформационнаяБаза,ТекстОшибки);
		Если ТипЗнч(Мас) <> Тип("Массив") Тогда //Какой-то  косяк с получением списка пользователей
			Сообщить("Не удалось получить массив пользователей. " + ТекстОшибки);
			Возврат;
		КонецЕсли;	
		
		//Ну и начнем обработку данных
		Для каждого ХХХ Из Мас Цикл
			ПользовательКлючПоиска = ВРег(СтрЗаменить(ХХХ.ПолноеИмя," ","")); 
			
			СтруктураПоиска = Новый Структура("ФИО", ПользовательКлючПоиска); 
			МассивНайденныхСтрок = ТБл.НайтиСтроки(СтруктураПоиска); 	
			фРаботник = (МассивНайденныхСтрок.Количество() <> 0);
			Если фРаботник Тогда
				Продолжить;
			КонецЕсли;	
			
			СтруктураПоиска = Новый Структура("ПользовательКлючПоиска", ПользовательКлючПоиска); 
			МассивНайденныхСтрок = ТблИскл.НайтиСтроки(СтруктураПоиска); 	
			фИсключаемый = (МассивНайденныхСтрок.Количество() <> 0);
			Если фИсключаемый Тогда
				Продолжить;
			КонецЕсли;	
			
			нСтр = Объект.ПользователиИБ.Добавить();
			нСтр.Пользователь = ХХХ.ПолноеИмя;
			нСтр.Имя = ХХХ.Имя;
		КонецЦикла;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренестиВыделенныеСлева(Команда)
	стрПереченьПользователей = "";
	Для Каждого ХХХ Из Объект.ПользователиИБ Цикл
		Если ХХХ.ФлагВыбора = Истина Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("Пользователь", ХХХ.Пользователь);
			Мас = Объект.ИсключаемыеПользователи.НайтиСтроки(Отбор);			
			Если Мас.Количество() = 0 Тогда
				нСтр = Объект.ИсключаемыеПользователи.Добавить();
				нСтр.Пользователь = ХХХ.Пользователь;
			Иначе	
				стрПереченьПользователей = стрПереченьПользователей + ХХХ.Пользователь + Символы.ПС;
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	Если стрПереченьПользователей <> "" Тогда
		тПредупреждения = "Внимание!" + Символы.ПС + Символы.ПС + "Вы повторно пытаетесь добавить пользователей, 
						|которые уже содержатся в списке исключаемых.
						|Эти пользователи не будут повторно перенесены." + Символы.ПС + Символы.ПС + стрПереченьПользователей;
		ПоказатьПредупреждение(, тПредупреждения);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПеренестиВыделенныеСправа(Команда)
	Для Каждого ХХХ Из Объект.ИсключаемыеПользователи Цикл
		Если ХХХ.ФлагВыбора = Истина Тогда
			Объект.ИсключаемыеПользователи.Удалить(ХХХ);
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьРегистр(Команда)
	ЗаписатьРегистр();
КонецПроцедуры

&НаСервере
Процедура ЗаписатьРегистр()
	НаборЗаписей = РегистрыСведений.ИсключаемыеПользователи.СоздатьНаборЗаписей(); 
	НаборЗаписей.Отбор.ИнформационнаяБаза.Установить(Объект.ИнформационнаяБаза); 
	НаборЗаписей.Записать();
	Для Каждого ХХХ Из Объект.ИсключаемыеПользователи Цикл 
		НоваяЗапись = НаборЗаписей.Добавить(); 
		НоваяЗапись.ИнформационнаяБаза = Объект.ИнформационнаяБаза; 
		НоваяЗапись.Пользователь = ХХХ.Пользователь; 
		НоваяЗапись.ПользовательКлючПоиска = ВРег(СтрЗаменить(ХХХ.Пользователь," ","")); 
	КонецЦикла; 
	НаборЗаписей.Записать();    
КонецПроцедуры

