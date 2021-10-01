﻿//Описания
//***Реквизиты формы:
//"Подразделение" - это список значений, содержащий перечень подразделений, которые учавствуют в проекте.

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	НомерТекСтрокиНаЛинии = 0;
	НомерТекСтрокиГараж = 0;
	НомерТекСтрокиПодразделения = 0;
	НомерТекСтрокиВРемонте = 0;
	
	//Вариант бегунка по счетчику тактов
	СчетчикТактовЛинияГараж = 1;
	
	Если Константы.НаименованиеБазыПЛ.Получить() = "" Тогда
		Сообщить("Не заполнена константа ""Наименование базы ПЛ""");
	ИначеЕсли Константы.АдресСервераПЛ.Получить() = "" Тогда
		Сообщить("Не заполнена константа ""Адрес сервера ПЛ""");
	Иначе	
		ЗаполнитьТаблицы();
		//Организуем раскраску строк в таблицах гаража и ремонта в зависимости от цвета гаража
		РаскрасимТаблицыВГаражеИВРемонте();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьЗаголовокКлиентскогоПриложения("Рабочий стол проекта ""ОКО"" - " + ВернутьЗначениеКонстанты("НаименованиеОрганизации"));
	
	//Сообщить(ПараметрЗапуска); //http://10.8.85.12/ProjectOKO/?c=oko-admin
	
	//Определим в зависимости от разрешения экрана размер шрифта
	МассивРазмеров = ПолучитьИнформациюЭкрановКлиента();
	ОпределитьРазмерШрифтовФормы(МассивРазмеров);
	
	//Сообщить(ПараметрЗапуска);
	#Если ВебКлиент Тогда
		ПользовательОС = ПараметрЗапуска;
		//Сообщить(ПараметрЗапуска);
	#Иначе	
		ПользовательОС = ПолучитьПользователяWindows();
	 #КонецЕсли
	
	//Вариант бегунка по счетчику тактов
	КоличествоТактовЛинияГараж  = Макс(10,ПереченьТСНаЛинии.Количество(),ПереченьТСВГараже.Количество());
	
	Если ПользовательОС = "sokotovap"  Тогда 
		//ПодключитьОбработчикОжидания("ОбработчикБегунокРММ", 1, Ложь);
		//ПодключитьОбработчикОжидания("ОбработчикБегунокЛинияГараж",1 , Ложь);
		//ПодключитьОбработчикОжидания("ОбработчикСменаПодразделенияИзКонстанты", 1, Ложь);
	ИначеЕсли ПользовательОС = "oko-rmm"  Тогда 
		ПодключитьОбработчикОжидания("ОбработчикБегунокРММ", 2, Ложь);
	ИначеЕсли ПользовательОС = "oko-obdd" Или ПользовательОС = "oko-kpp" Или ПользовательОС = "oko-kpp-2" Тогда 
		ПодключитьОбработчикОжидания("ОбработчикБегунокЛинияГараж", 2, Ложь);
	ИначеЕсли ПользовательОС = "oko-disp" Тогда 
		ПодключитьОбработчикОжидания("ОбработчикБегунокЛинияГараж", 2, Ложь);
		//Этот обработчик только для диспетчерской, где стоит Алиса
		ПодключитьОбработчикОжидания("ОбработчикСменаПодразделенияИзКонстанты", 1, Ложь);
	КонецЕсли;	

	ПодключитьОбработчикОжидания("ОбработчикОбновлениеОсновныхТаблиц", 600, Ложь);

	ВидимостьЭлементовФормы(Истина);
КонецПроцедуры


&НаСервере
Функция ВернутьЗначениеКонстанты(НаименованиеКонстанты);
	Возврат Константы[НаименованиеКонстанты].Получить();
КонецФункции


&НаКлиенте
Процедура ОбработчикБегунокЛинияГараж()
	
	//Вариант со счетчиком
	Если СчетчикТактовЛинияГараж < КоличествоТактовЛинияГараж Тогда
		СчетчикТактовЛинияГараж = СчетчикТактовЛинияГараж + 1;
		
		Если ПереченьТСНаЛинии.Количество() > 0 Тогда
			Если НомерТекСтрокиНаЛинии > (ПереченьТСНаЛинии.Количество() - 2) Тогда //была последняя строка списка
				НомерТекСтрокиНаЛинии = 0;
			Иначе
				НомерТекСтрокиНаЛинии = НомерТекСтрокиНаЛинии + 1;
			КонецЕсли;	
			СтрокаТЗ = ПереченьТСНаЛинии[НомерТекСтрокиНаЛинии]; 
			ИдентификаторСтроки = СтрокаТЗ.ПолучитьИдентификатор();
			Элементы.ПереченьТСНаЛинии.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
 		
		Если ПереченьТСВГараже.Количество() > 0 Тогда
			Если НомерТекСтрокиГараж > (ПереченьТСВГараже.Количество() - 2) Тогда //была последняя строка списка
				НомерТекСтрокиГараж = 0;
			Иначе
				НомерТекСтрокиГараж = НомерТекСтрокиГараж + 1;
			КонецЕсли;	
			СтрокаТЗ = ПереченьТСВГараже[НомерТекСтрокиГараж]; 
			ИдентификаторСтроки = СтрокаТЗ.ПолучитьИдентификатор();
			Элементы.ПереченьТСВГараже.ТекущаяСтрока = ИдентификаторСтроки;
		КонецЕсли;
		
		
	Иначе	
		ОбработчикСменаПодразделения();
		КоличествоТактовЛинияГараж  = Макс(10,ПереченьТСНаЛинии.Количество(),ПереченьТСВГараже.Количество());
		СчетчикТактовЛинияГараж = 1;
	КонецЕсли;	
	
	
	
	////Вариант со сменой подразделения
	//Если ПереченьТСНаЛинии.Количество() > 0 Тогда
	//	Если НомерТекСтрокиНаЛинии > (ПереченьТСНаЛинии.Количество() - 2) Тогда //была последняя строка списка
	//		//Сменим подразделение
	//		ОбработчикСменаПодразделения();
	//		Если ПереченьТСНаЛинии.Количество() = 0 Тогда //Тот случай, когда нет данных в таблице "ПереченьТСНаЛинии"
	//			Возврат;
	//		КонецЕсли;	
	//	Иначе
	//		НомерТекСтрокиНаЛинии = НомерТекСтрокиНаЛинии + 1;
	//	КонецЕсли;	
	//	СтрокаТЗ = ПереченьТСНаЛинии[НомерТекСтрокиНаЛинии]; 
	//	ИдентификаторСтроки = СтрокаТЗ.ПолучитьИдентификатор();
	//	Элементы.ПереченьТСНаЛинии.ТекущаяСтрока = ИдентификаторСтроки;
	//Иначе
	//	НомерТекСтрокиНаЛинии = НомерТекСтрокиНаЛинии + 1;
	//	//По времени подразделение будет находиться на форме 10 тактов бегунка строки
	//	Если НомерТекСтрокиНаЛинии > 10 Тогда
	//		ОбработчикСменаПодразделения();
	//	КонецЕсли;	
	//КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОбновлениеОсновныхТаблиц()
	ОбновлениеОсновныхТаблиц();
КонецПроцедуры

&НаКлиенте
Процедура ОбновлениеОсновныхТаблиц()
	НомерТекСтрокиПодразделения = 0;
	НомерТекСтрокиНаЛинии = 0;
	НомерТекСтрокиГараж = 0;
	ЗаполнитьТаблицы();
	ВидимостьЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСменаТекущейСтроки()
	//Вариант со сменой подразделения
	Если ПереченьТСНаЛинии.Количество() > 0 Тогда
		Если НомерТекСтрокиНаЛинии > (ПереченьТСНаЛинии.Количество() - 2) Тогда //была последняя строка списка
			//Сменим подразделение
			ОбработчикСменаПодразделения();
			Если ПереченьТСНаЛинии.Количество() = 0 Тогда //Тот случай, когда нет данных в таблице "ПереченьТСНаЛинии"
				Возврат;
			КонецЕсли;	
		Иначе
			НомерТекСтрокиНаЛинии = НомерТекСтрокиНаЛинии + 1;
		КонецЕсли;	
		СтрокаТЗ = ПереченьТСНаЛинии[НомерТекСтрокиНаЛинии]; 
		ИдентификаторСтроки = СтрокаТЗ.ПолучитьИдентификатор();
		Элементы.ПереченьТСНаЛинии.ТекущаяСтрока = ИдентификаторСтроки;
	Иначе
		НомерТекСтрокиНаЛинии = НомерТекСтрокиНаЛинии + 1;
		//По времени подразделение будет находиться на форме 10 тактов бегунка строки
		Если НомерТекСтрокиНаЛинии > 10 Тогда
			ОбработчикСменаПодразделения();
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСменаПодразделения()
	НомерТекСтрокиНаЛинии = 0;
	НомерТекСтрокиГараж = 0;
	Если НомерТекСтрокиПодразделения > (Элементы.Подразделение.СписокВыбора.Количество() - 2) Тогда //была последняя строка списка
		НомерТекСтрокиПодразделения = 0;
	Иначе
		НомерТекСтрокиПодразделения = НомерТекСтрокиПодразделения + 1;
	КонецЕсли;	
	Подразделение = Элементы.Подразделение.СписокВыбора[НомерТекСтрокиПодразделения].Значение;
	ПодразделениеПриИзменении();
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикСменаПодразделенияИзКонстанты()
	
	ПодразделениеИзКонстанты = ПолучитьЗначениеКонстанты("окоЗначениеДляФормыЭкрана");
	Если ЗначениеЗаполнено(ПодразделениеИзКонстанты) Тогда
		НомерТекСтрокиНаЛинии = 0;
		НомерТекСтрокиГараж = 0;
		Подразделение = ПодразделениеИзКонстанты;
		УстановитьЗначениеКонстанты("окоЗначениеДляФормыЭкрана");
		ПодразделениеПриИзменении();
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция ПолучитьЗначениеКонстанты(НаименованиеКонстанты)
	Возврат Константы[НаименованиеКонстанты].Получить();
КонецФункции

&НаСервере
Процедура УстановитьЗначениеКонстанты(НаименованиеКонстанты)
	Константы[НаименованиеКонстанты].Установить("");
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикБегунокРММ()
	//Вариант простого бегунка
	Если ПереченьТСВРемонтеПолный.Количество() > 0 Тогда
		Если НомерТекСтрокиВРемонте > (ПереченьТСВРемонтеПолный.Количество() - 2) Тогда
			НомерТекСтрокиВРемонте = 0;
		Иначе
			НомерТекСтрокиВРемонте = НомерТекСтрокиВРемонте + 1;
		КонецЕсли;	
		СтрокаТЗ = ПереченьТСВРемонтеПолный[НомерТекСтрокиВРемонте]; 
		ИдентификаторСтроки = СтрокаТЗ.ПолучитьИдентификатор();
		Элементы.ПереченьТСВРемонтеПолный.ТекущаяСтрока = ИдентификаторСтроки;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьРазмерШрифтовФормы(МассивРазмеров)
//	Если ТипЗнч(МассивРазмеров) = Тип("ФиксированныйМассив") Тогда 
		ШиринаЭкрана = МассивРазмеров[0].Ширина;
		Если ШиринаЭкрана <= 1920 Тогда
			шРазделов = 90;
			тблРазмерШрифта = 14;
			шГарНомер = 8 - 2;
			шГосНомер = 15;
			шТС = 50;
			шИтого = 75;
			вИтого = 20;
			шрифтИтого = 50;
			шрифтИтогоМалый = 20;
		Иначе
			шРазделов = 200;
			тблРазмерШрифта = 40;
			шГарНомер = 25-10;
			шГосНомер = 60-20;
			шТС = 80;
			шИтого = 160;
			вИтого = 45;
			шрифтИтого = 100;
			шрифтИтогоМалый = 58;
		КонецЕсли;	
//	КонецЕсли;	
	
	Элементы.ГруппаНаЛинии.Ширина = шРазделов;
	Элементы.ГруппаВГараже.Ширина = шРазделов;
	Элементы.ГруппаНетДанныхБСМТС.Ширина = шРазделов;
	Элементы.ГруппаНарушенияБДД.Ширина = шРазделов;
	
	//Группа "На линии"
	Элементы.НадписьТСНаЛинииСтр.Шрифт = Новый Шрифт(Элементы.НадписьТСНаЛинииСтр.Шрифт,,тблРазмерШрифта);
	Элементы.НадписьТСНаЛинииКол.Шрифт = Новый Шрифт(Элементы.НадписьТСНаЛинииСтр.Шрифт,,тблРазмерШрифта);
	Элементы.НадписьТСНаЛинииКолСНарушениями.Шрифт = Новый Шрифт(Элементы.НадписьТСНаЛинииСтр.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСНаЛинии.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСНаЛинииГаражныйНомер.Ширина = шГарНомер;
	Элементы.ПереченьТСНаЛинииГосударственныйНомер.Ширина = шГосНомер;
	Элементы.ПереченьТСНаЛинииТС.Ширина = шТС + 20;
	
	//Группа "В гараже"
	Элементы.НадписьТСВГаражеСтр.Шрифт = Новый Шрифт(Элементы.НадписьТСВГаражеСтр.Шрифт,,тблРазмерШрифта);
	Элементы.НадписьТСВГаражеКол.Шрифт = Новый Шрифт(Элементы.НадписьТСВГаражеСтр.Шрифт,,тблРазмерШрифта);
	Элементы.НадписьТСВГаражеКолСНарушениями.Шрифт = Новый Шрифт(Элементы.НадписьТСВГаражеСтр.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСВГараже.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСВГаражеГаражныйНомер.Ширина = шГарНомер;
	Элементы.ПереченьТСВГаражеГосударственныйНомер.Ширина = шГосНомер;
	Элементы.ПереченьТСВГаражеТС.Ширина = шТС;
	
	Элементы.ГруппаМалоеОбщее.Ширина = шРазделов;
	Элементы.ГруппаМалоеОбщее0.Ширина = (шРазделов/5)*2 - 2;
	Элементы.ГруппаМалоеОбщее1.Ширина = (шРазделов/5)*2 - 2;
	
	Элементы.ГруппаМалоеОбщееЛиния.Ширина = (шРазделов/5)*2 - 4;
	Элементы.ГруппаМалоеОбщееРемонт.Ширина = (шРазделов/5)*2 - 4;
	Элементы.ГруппаМалоеОбщееГараж.Ширина = (шРазделов/5)*2 - 4;
	Элементы.ГруппаМалоеОбщееБСМТС.Ширина = (шРазделов/5)*2 - 4;
	
	Элементы.ГруппаМалоеОбщееИтого.Ширина = шРазделов/5 - 4;
	ЭтаФорма.Элементы.НадписьМалоеОбщееИтого.Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтого + 10);
	
	
	ЭтаФорма.Элементы.НадписьИтого0КолСНарушениями.Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтого);
	ЭтаФорма.Элементы.НадписьИтого0Кол1СНарушениями.Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтогоМалый);
	ЭтаФорма.Элементы.НадписьИтого1КолСНарушениями.Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтого);
	ЭтаФорма.Элементы.НадписьИтого1Кол1СНарушениями.Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтогоМалый);
	
	//Группа "Без БСМТС"
	Элементы.НадписьТСБезДанныхСтр.Шрифт = Новый Шрифт(Элементы.НадписьТСНаЛинииСтр.Шрифт,,тблРазмерШрифта);
	Элементы.НадписьТСБезДанныхКол.Шрифт = Новый Шрифт(Элементы.НадписьТСНаЛинииСтр.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСНетДанных.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСНетДанныхГаражныйНомер.Ширина = шГарНомер;
	Элементы.ПереченьТСНетДанныхГосударственныйНомер.Ширина = шГосНомер;
	
	//Группа "Нарушения БДД"
	Элементы.НадписьТСНаЛинииСНарушениями.Шрифт = Новый Шрифт(Элементы.НадписьТСНаЛинииСтр.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТССНарушениями.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТССНарушениямиГаражныйНомер.Ширина = шГарНомер;
	Элементы.ПереченьТССНарушениямиГосударственныйНомер.Ширина = шГосНомер;
	Элементы.ПереченьТССНарушениямиНаименованиеНарушения.Ширина = шГосНомер + 10;
	Элементы.ПереченьТССНарушениямиТС.Ширина = шГосНомер + 20; //40
	
	//Группа "В ремонте по подразделению"
	Элементы.ПереченьТСВРемонте.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.НадписьТСВРемонтеСтр.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.НадписьТСВРемонтеКол.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСВРемонтеГаражныйНомер.Ширина = шГарНомер;
	Элементы.ПереченьТСВРемонтеГосударственныйНомер.Ширина = шГосНомер;
	Элементы.ПереченьТСВРемонтеПолныйДатаНачалаРемонта.Ширина = шГосНомер;
	
	//Группа "Ремонт полный"
	Элементы.НадписьТСВРемонтеПолный.Шрифт = Новый Шрифт(Элементы.НадписьТСНаЛинииСтр.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСВРемонтеПолный.Шрифт = Новый Шрифт(Элементы.ПереченьТСНаЛинии.Шрифт,,тблРазмерШрифта);
	Элементы.ПереченьТСВРемонтеПолныйГаражныйНомер.Ширина = шГарНомер;
	Элементы.ПереченьТСВРемонтеПолныйГосударственныйНомер.Ширина = шГосНомер;
	
	Для х = 0 по 3 Цикл
		//Это для большого ИТОГО
		ЭтаФорма.Элементы[Строка("НадписьИтого" + х + "Стр")].Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтого);
		ЭтаФорма.Элементы[Строка("НадписьИтого" + х + "Кол")].Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтого);
		
		//Это для малого ИТОГО
		ЭтаФорма.Элементы[Строка("НадписьИтого" + х + "Стр1")].Ширина = шРазделов/2 - 6;
		ЭтаФорма.Элементы[Строка("НадписьИтого" + х + "Стр1")].Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтогоМалый);
		ЭтаФорма.Элементы[Строка("НадписьИтого" + х + "Кол1")].Шрифт = Новый Шрифт(Элементы.НадписьИтогоОбщее.Шрифт,,шрифтИтогоМалый);
		
		ЭтаФорма.Элементы[Строка("ГруппаИтого" + х)].Высота = вИтого;
		ЭтаФорма.Элементы[Строка("ГруппаИтого" + х)].Ширина = шИтого;
	КонецЦикла;	
	
КонецПроцедуры


#Область ЗаполнениеОсновныхТаблиц

&НаСервере
Процедура ЗаполнитьТаблицы()
	//+1. Заполним наши основные учетные таблицы
	ЗаполнитьОсновныеТаблицы();
	//-1. Заполним наши основные учетные таблицы
	
	//+2. Заполним таблицы с отбором по подразделению
	ЗаполнитьТаблицыПоПодразделению(Подразделение);
	ЗаполнитьПереченьТСВРемонтеПоПодразделению(Подразделение);
	//-2. Заполним таблицы с отбором по подразделению
	
	ЗаполнитьТаблицуНарушений();
	
КонецПроцедуры	

&НаСервере
Процедура  ЗаполнитьПереченьТСВРемонтеПолный()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	уатРемонтныйЛист.ТС КАК ТС,
		|	уатРемонтныйЛист.ТС.ГаражныйНомер КАК ГаражныйНомер,
		|	уатМестонахождениеТССрезПоследних.Подразделение.Наименование КАК Подразделение,
		|	уатРемонтныйЛист.ТС.ГосударственныйНомер КАК ГосударственныйНомер,
		|	уатРемонтныйЛист.ДатаНачала КАК ДатаНачалаРемонта,
		|	уатРемонтныйЛист.ДатаОкончанияПлан КАК ДатаОкончанияПлановая,
		|	уатРемонтныйЛист.Гараж КАК Гараж
		|ИЗ
		|	Документ.уатРемонтныйЛист КАК уатРемонтныйЛист
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаЗапроса, ) КАК уатМестонахождениеТССрезПоследних
		|		ПО уатРемонтныйЛист.ТС = уатМестонахождениеТССрезПоследних.ТС
		|ГДЕ
		|	уатРемонтныйЛист.ПометкаУдаления = ЛОЖЬ
		|	И уатРемонтныйЛист.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|	И уатРемонтныйЛист.Дата >= ДАТАВРЕМЯ(2020, 1, 1, 0, 0, 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачалаРемонта
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ДатаЗапроса", ТекущаяДата());
	ПереченьТСВРемонтеПолный.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

&НаСервере
Процедура  ЗаполнитьОсновныеТаблицы(Стк = Неопределено)
	
	Стк = Обработки.РабочийСтолПроектОКО.ПолучитьОсновныеТаблицы();
	
	Если ТипЗнч(Стк) <> Тип("Структура") Тогда
		Сообщить(Стк);
		Возврат;
	КонецЕсли;	
	
	
	ПереченьТСВРемонтеПолный.Загрузить(Стк.тбРем);
	ПереченьТСВЭксплуатации.Загрузить(Стк.тбЭксп);
	
	Для Каждого ХХХ Из Стк.тбГар Цикл
		нСтрока = ПереченьГаражей.Добавить();
		нСтрока.ЦветГаража = ХХХ.ЦветГаража.Получить();
		ЗаполнитьЗначенияСвойств(нСтрока,ХХХ,,"ЦветГаража");
	КонецЦикла;	
	
	//Таблица значений "ПереченьПодразделений" необходима для смены текущего подразделения
	ЗаполнитьПереченьПодразделений();
	
	//Установим на форме реквизит "Подразделение"
	Подразделение = ПереченьПодразделений[0].Подразделение;
	
КонецПроцедуры

&НаСервере
Процедура  ЗаполнитьПереченьТСВЭксплуатации(МассивИсключаемыхОбъектов)
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	уатМестонахождениеТССрезПоследних.ТС.Наименование КАК ТС,
		|	уатМестонахождениеТССрезПоследних.Подразделение.Наименование КАК Подразделение,
		|	1 КАК Количество,
		|	уатМестонахождениеТССрезПоследних.ТС.ИДвСистемеНавигации КАК ИДвСистемеНавигации,
		|	уатМестонахождениеТССрезПоследних.ТС.СистемаМониторинга.Наименование КАК СистемаМониторинга,
		|	уатМестонахождениеТССрезПоследних.ТС.ГаражныйНомер КАК ГаражныйНомер,
		|	уатМестонахождениеТССрезПоследних.ТС.ГосударственныйНомер КАК ГосударственныйНомер
		|ИЗ
		|	РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаЗапроса, ) КАК уатМестонахождениеТССрезПоследних
		|ГДЕ
		|	уатМестонахождениеТССрезПоследних.Состояние.ЗапретитьВыпискуПЛ = ЛОЖЬ
		|	И уатМестонахождениеТССрезПоследних.Состояние <> ЗНАЧЕНИЕ(Справочник.уатСостояниеТС.Привлеченный)
		|	И НЕ уатМестонахождениеТССрезПоследних.Подразделение В (&МассивИскПодразделений)
		|	И НЕ уатМестонахождениеТССрезПоследних.ТС В (&МассивИскТС)
		|
		|УПОРЯДОЧИТЬ ПО
		|	уатМестонахождениеТССрезПоследних.ТС.ГаражныйНомер
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ДатаЗапроса", ТекущаяДата());
	Запрос.УстановитьПараметр("МассивИскПодразделений", МассивИсключаемыхОбъектов);
	Запрос.УстановитьПараметр("МассивИскТС", МассивИсключаемыхОбъектов);
	
	
	ПереченьТСВЭксплуатации.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПереченьПодразделений()
	Элементы.Подразделение.СписокВыбора.Очистить();
	//Эту ТЗ мы получаем из уже готовой ТЗ - "ПереченьТСВЭксплуатации"  - без дополнительных запросов
	ТЗ = ПереченьТСВЭксплуатации.Выгрузить(,"Подразделение,Количество");
	ТЗ.Свернуть("Подразделение","Количество");
	ТЗ.Сортировать("Подразделение");
	Для Каждого ХХХ Из ТЗ Цикл
		Элементы.Подразделение.СписокВыбора.Добавить(ХХХ.Подразделение);
	КонецЦикла;
	ПереченьПодразделений.Загрузить(ТЗ);
КонецПроцедуры

&НаСервере
Процедура  ЗаполнитьТаблицуНарушений()
	//Получим данные из БСМТС
	ДанныеБСМТС = ПолучитьДанныеИзБСМТС();
	Если ДанныеБСМТС = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	ПереченьТССНарушениями.Очистить();
	ПереченьТССНарушениями.Добавить();
	Для Каждого ХХХ Из ДанныеБСМТС Цикл
		ТекПарметры = ХХХ.Значение;
		Если ТекПарметры = Неопределено Тогда
			Продолжить;
		КонецЕсли;	
		СчетчикПревышенияСкорости = ТекПарметры.Получить("Final").Получить("OverspeedCount");
		Если СчетчикПревышенияСкорости = Неопределено Тогда
			СчетчикПревышенияСкорости = 0;
		КонецЕсли;	
		Если СчетчикПревышенияСкорости > 0 Тогда
			ИДТС = ТекПарметры.Получить("ID");
			НайдСтроки = ПереченьТСВЭксплуатации.НайтиСтроки(Новый Структура("ИДвСистемеНавигации", ИДТС));
			Если НайдСтроки.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли; 
			//Найдем текущий путевой лист
			
			//ПутевойЛист = ПолучитьПутевойЛист(ТС,ТекущаяДата());
			нСтрока = ПереченьТССНарушениями.Добавить();
			//нСтрока.ТС = ТС.Ссылка;
			//нСтрока.Водитель = ПутевойЛист.Водитель1.Наименование;
			нСтрока.НаименованиеНарушения = "Превышение скорости";
			нСтрока.КоличествоНарушений = СчетчикПревышенияСкорости;
			ЗаполнитьЗначенияСвойств(нСтрока,НайдСтроки[0]);
			//Сообщить(ТС.ГаражныйНомер + " - " + Строка(СчетчикПревышенияСкорости));
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеДляЗаполненияТаблиц

&НаСервере
Функция  ПолучитьМассивИсключаемыхОбъектов()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	юкИсключаемыеОбъектыИзПроектов.ИсключаемыйОбъект КАК ИсключаемыйОбъект
		|ИЗ
		|	РегистрСведений.юкИсключаемыеОбъектыИзПроектов КАК юкИсключаемыеОбъектыИзПроектов";
	
	Результат = Запрос.Выполнить().Выгрузить();
	Возврат Результат.ВыгрузитьКолонку("ИсключаемыйОбъект");
КонецФункции

&НаСервере
Функция ПолучитьДанныеИзБСМТС()
	
	ПутьДоФайлаДанных = Константы.окоПутьДоФайлаДанных.Получить();
	//Ф = Новый Файл("E:\Work\out.txt");
	Ф = Новый Файл(ПутьДоФайлаДанных);
	Если Не Ф.Существует() Тогда
		Возврат Неопределено;
	КонецЕсли;
	ДатаВремяБСМТС = Ф.ПолучитьВремяИзменения();
	//Текст = Новый ЧтениеТекста("E:\Work\out.txt");
	Текст = Новый ЧтениеТекста(ПутьДоФайлаДанных);
	ResponseText = Текст.Прочитать();
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(ResponseText);
	Response = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();
	
	Возврат Response;

КонецФункции

&НаСервере
Функция  ПолучитьПутевойЛист(ТранспортноеСредство,ДатаЗапроса)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	уатПутевойЛист.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.уатПутевойЛист КАК уатПутевойЛист
		|ГДЕ
		|	&ДатаЗапроса МЕЖДУ уатПутевойЛист.ДатаВыезда И уатПутевойЛист.ДатаВозвращения
		|	И уатПутевойЛист.ТранспортноеСредство = &ТранспортноеСредство";
	
	Запрос.УстановитьПараметр("ДатаЗапроса", ДатаЗапроса);
	Запрос.УстановитьПараметр("ТранспортноеСредство", ТранспортноеСредство);
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	Возврат Документы.уатПутевойЛист.ПустаяСсылка();
КонецФункции	

#КонецОбласти

#Область ЗаполнениеТаблицСОтборомПоПодразделению

&НаСервере
Процедура  ЗаполнитьПереченьТСВРемонтеПоПодразделению(Подразделение)
	Отбор = Новый Структура("Подразделение",Подразделение);
	ТЗ = ПереченьТСВРемонтеПолный.Выгрузить(Отбор);
	ПереченьТСВРемонте.Загрузить(ТЗ);
КонецПроцедуры

&НаСервере
Функция ПолучитьПереченьТСВЭксплуатацииПоПодразделению(Подразделение)
	Отбор = Новый Структура("Подразделение",Подразделение);
	ТЗ = ПереченьТСВЭксплуатации.Выгрузить(Отбор);
	Возврат ТЗ;
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицыПоПодразделению(Подразделение)
	
	//Очистим все наши таблицы
	ПереченьТСНаЛинии.Очистить();
	
	ПереченьТСВГараже.Очистить();
	//ПереченьТСВГараже.Добавить();
	
	ПереченьТСНетДанных.Очистить();
	ПереченьТСНетДанных.Добавить();
	
	ДатаСравнения = НачалоДня(ТекущаяДата() - 1 * 24 * 60 * 60);
	СдвигЧасовогоПояса = 5;
	
	//Получим данные из БСМТС
	ДанныеБСМТС = ПолучитьДанныеИзБСМТС();
	Если ДанныеБСМТС = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ПереченьТСВЭксплуатацииПоПодразделению = ПолучитьПереченьТСВЭксплуатацииПоПодразделению(Подразделение);
	
	Для Каждого ХХХ Из ПереченьТСВЭксплуатацииПоПодразделению Цикл
		
		//Сначала проверим, а нет ли этой машинки в ремонте.
		НайдСтроки = ПереченьТСВРемонтеПолный.НайтиСтроки(Новый Структура("ГаражныйНомер", ХХХ.ГаражныйНомер));
		Если НайдСтроки.Количество() > 0 Тогда
			//И если она в ремонте - то она нам не нужна для последующего анализа
			Продолжить;
		КонецЕсли; 
   		
		Если СокрЛП(ХХХ.ИДвСистемеНавигации) = "" Тогда //Нет привязки к БСМТС
			нСтрока = ПереченьТСНетДанных.Добавить();
			ЗаполнитьЗначенияСвойств(нСтрока,ХХХ);
			нСтрока.Причина = "Нет привязки к БСМТС";
			Продолжить;
		КонецЕсли;	
		
		ТекОбъект = ДанныеБСМТС.Получить(ХХХ.ИДвСистемеНавигации);
		
		Если ТекОбъект = Неопределено Тогда //В данных из БСМТС нет объекта с таким ИД
			нСтрока = ПереченьТСНетДанных.Добавить();
			ЗаполнитьЗначенияСвойств(нСтрока,ХХХ);
			нСтрока.Причина = "Нет в данных БСМТС";
			Продолжить;
		КонецЕсли;	
		
		Если ТипЗнч(ТекОбъект) = Тип("Соответствие") Тогда //Данные есть в нужном нам виде
			
			//Получим дату и время последних данных
			LastData = ТекОбъект.Получить("LastData");
			LastData = СтрЗаменить(LastData,"+0500","");
			LastData = ПрочитатьДатуJSON(LastData, ФорматДатыJSON.Microsoft);
			//LastData = LastData + (ХХХ.ТС.СистемаМониторинга.СдвигЧасовогоПояса * 60 * 60);
			LastData = LastData + (СдвигЧасовогоПояса * 60 * 60);
			
			//Получим последнее местоположение
			ТекущееПоложение = ТекОбъект.Получить("Final").Получить("CurrLocation");
			
			//Попробуем найти наше текущее положение в перечне Гаражей
			НайдСтроки = ПереченьГаражей.НайтиСтроки(Новый Структура("НаименованиеГеозоны", ТекущееПоложение));
			Если НайдСтроки.Количество() > 0 Тогда //Нашли такой гараж - значит по любому ТС в таблицу "Гараж"
				нСтрока = ПереченьТСВГараже.Добавить();
				ЗаполнитьЗначенияСвойств(нСтрока,ХХХ);
				нСтрока.Гараж = НайдСтроки[0].Наименование;
				Если ДатаВремяБСМТС - LastData > 600 Тогда
					нСтрока.ФлагНетСвязи = 1;
					нСтрока.ТекущееПоложениеДата = LastData;
				КонецЕсли;	
			Иначе //Последнее местонахождение за пределами наших баз
				Если  LastData < ДатаСравнения Тогда //Последней дате данных БСМТС более суток - однозначно в таблицу "Без БСМТС"
					нСтрока = ПереченьТСНетДанных.Добавить();
					ЗаполнитьЗначенияСвойств(нСтрока,ХХХ);
					нСтрока.Причина = "Данные за: " + Строка(LastData);
				Иначе // Все остальное в таблицу "Линия"
					нСтрока = ПереченьТСНаЛинии.Добавить();
					ЗаполнитьЗначенияСвойств(нСтрока,ХХХ);
					Если (LastData > ДатаСравнения) И (ДатаВремяБСМТС - LastData > 600) Тогда
						нСтрока.ФлагНетСвязи = 1;
						нСтрока.ТекущееПоложениеДата = LastData;
					КонецЕсли;	
				КонецЕсли;	
			КонецЕсли;	
		Иначе //В данных из БСМТС объект с таким ИД есть, но этот объект имеет значение NULL (неопределено)
			нСтрока = ПереченьТСНетДанных.Добавить();
			ЗаполнитьЗначенияСвойств(нСтрока,ХХХ);
			нСтрока.Причина = "Данные БСМТС пустые";
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура КомандаОткрытьФормуАдминистратора(Команда)
	ОткрытьФорму("Обработка.РабочийСтолПроектОКО.Форма.ФормаАдминистрирования");
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновитьДанныеОсновныхТаблиц(Команда)
	ОбновлениеОсновныхТаблиц();
	РаскрасимТаблицыВГаражеИВРемонте();
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПриИзмененииЭлементовФормы

&НаКлиенте
Процедура ВидимостьЭлементовФормы(ЭтоПриОткрытии = Ложь)
	
	
	Если ЭтоПриОткрытии Тогда //При открытии формы - жестко контролируем окно для пользователя
		
	  //  #Если ВебКлиент Тогда
	  //  	ПользовательОС = "sokotovap";
	  //  #Иначе	
	  //  	ПользовательОС = ПолучитьПользователяWindows();
	  //  	//Сообщить(ПараметрЗапуска);
	  //#КонецЕсли
	  
		//oko-rmm 1234567
		//oko-kpp 1234567
		//oko-kpp-2 1234567
		//oko-disp 1234567
		//oko-obdd 1234567
		//oko-admin 1234567
		
		//ПользовательОС = "oko-kpp-2";
		ЭтаФорма.Элементы.ГруппаАдминистрирование.Видимость = ЛОЖЬ;
		Если ПользовательОС = "sokotovap" Тогда
			ПереключательРазделы = 0;
			ЭтаФорма.Элементы.ГруппаАдминистрирование.Видимость = Истина;
		ИначеЕсли ПользовательОС = "oko-admin"Тогда //
			ПереключательРазделы = 0;
			ЭтаФорма.Элементы.ГруппаАдминистрирование.Видимость = Истина;
			Элементы.ПереченьТСНаЛинии.АктивизироватьПоУмолчанию = Истина;
		ИначеЕсли ПользовательОС = "oko-kpp" Тогда
			ПереключательРазделы = 0;
			Элементы.ГруппаВГараже.Видимость = ЛОЖЬ;
			Элементы.ПереченьТСНаЛинии.АктивизироватьПоУмолчанию = Истина;
		ИначеЕсли ПользовательОС = "oko-kpp-2" Тогда
			ПереключательРазделы = 0;
			Элементы.ГруппаНаЛинии.Видимость = ЛОЖЬ;
			Элементы.ПереченьТСНаЛинии.АктивизироватьПоУмолчанию = Истина;
		ИначеЕсли ПользовательОС = "oko-disp" Тогда	
			ПереключательРазделы = 0;
		ИначеЕсли ПользовательОС = "oko-rmm" Тогда	
			ПереключательРазделы = 2;
		ИначеЕсли ПользовательОС = "oko-obdd" Тогда	
			ПереключательРазделы = 1;
		Иначе	
			ПереключательРазделы = 4;
			//Элементы.ПереченьТСНаЛинии.АктивизироватьПоУмолчанию = Истина;
		КонецЕсли;	
	КонецЕсли;	
	
	Для х = 0 По 4 Цикл
		ЭтаФорма.Элементы[Строка("Группа" + х)].Видимость = ( ЭтаФорма.Элементы[Строка("Группа" + х)].Имя = ("Группа" + ПереключательРазделы));
	КонецЦикла;	
	
	//Реквизит "Подразделение" нам нужен не во всех разделах (окнах)
	ЭтаФорма.Элементы.Подразделение.Видимость = ((ПользовательОС = "sokotovap") Или (ПользовательОС = "oko-admin") Или (ПереключательРазделы = 1)  Или (ПереключательРазделы = 3) Или (ПереключательРазделы = 4));
	
	
	
	ЭтаФорма.Элементы.НадписьТСНаЛинииСтр.Заголовок = "ТС на линии - " + Строка(ЭтаФорма.Подразделение);
	ЭтаФорма.Элементы.НадписьТСНаЛинииКол.Заголовок = Строка(ПереченьТСНаЛинии.Количество());
	ЭтаФорма.Элементы.НадписьТСНаЛинииКолСНарушениями.Заголовок = "(" + ПереченьТСНаЛинии.Итог("ФлагНетСвязи") + ")";
	ЭтаФорма.Элементы.НадписьТСВГаражеСтр.Заголовок = "ТС в гараже - " + Строка(ЭтаФорма.Подразделение);
	ЭтаФорма.Элементы.НадписьТСВГаражеКол.Заголовок = Строка(ПереченьТСВГараже.Количество());
	ЭтаФорма.Элементы.НадписьТСВГаражеКолСНарушениями.Заголовок = "(" + ПереченьТСВГараже.Итог("ФлагНетСвязи") + ")";
	
	ЭтаФорма.Элементы.НадписьТСВРемонтеСтр.Заголовок = "ТС в ремонте  - " + Строка(ЭтаФорма.Подразделение);
	ЭтаФорма.Элементы.НадписьТСВРемонтеКол.Заголовок = Строка(ПереченьТСВРемонте.Количество());
	
	ЭтаФорма.Элементы.НадписьТСБезДанныхСтр.Заголовок = "ТС без данных БСМТС - " + Строка(ЭтаФорма.Подразделение);
	ЭтаФорма.Элементы.НадписьТСБезДанныхКол.Заголовок = Строка(ПереченьТСНетДанных.Количество() - 1);
	
	ЭтаФорма.Элементы.НадписьИтого0Кол.Заголовок = Строка(ПереченьТСНаЛинии.Количество());
	ЭтаФорма.Элементы.НадписьИтого0КолСНарушениями.Заголовок = "(" + ПереченьТСНаЛинии.Итог("ФлагНетСвязи") + ")";
	
	ЭтаФорма.Элементы.НадписьИтого0Кол1.Заголовок = Строка(ПереченьТСНаЛинии.Количество());
	ЭтаФорма.Элементы.НадписьИтого0Кол1СНарушениями.Заголовок = "(" + ПереченьТСНаЛинии.Итог("ФлагНетСвязи") + ")";
	
	ЭтаФорма.Элементы.НадписьИтого1Кол.Заголовок = Строка(ПереченьТСВГараже.Количество());
	ЭтаФорма.Элементы.НадписьИтого1КолСНарушениями.Заголовок = "(" + ПереченьТСВГараже.Итог("ФлагНетСвязи") + ")";
	
	ЭтаФорма.Элементы.НадписьИтого2Кол.Заголовок = Строка(ПереченьТСВРемонте.Количество());
	ЭтаФорма.Элементы.НадписьИтого3Кол.Заголовок = Строка(ПереченьТСНетДанных.Количество() - 1);
	
	ЭтаФорма.Элементы.НадписьИтого1Кол1.Заголовок = Строка(ПереченьТСВГараже.Количество());
	ЭтаФорма.Элементы.НадписьИтого1Кол1СНарушениями.Заголовок = "(" + ПереченьТСВГараже.Итог("ФлагНетСвязи") + ")";
	
	ЭтаФорма.Элементы.НадписьИтого2Кол1.Заголовок = Строка(ПереченьТСВРемонте.Количество());
	ЭтаФорма.Элементы.НадписьИтого3Кол1.Заголовок = Строка(ПереченьТСНетДанных.Количество() - 1);
	
	ЭтаФорма.Элементы.НадписьТСВРемонтеПолный.Заголовок = "ТС находящиеся в ремонте - " + Строка(ПереченьТСВРемонтеПолный.Количество());
	
	НайдСтроки = ПереченьПодразделений.НайтиСтроки(Новый Структура("Подразделение", ЭтаФорма.Подразделение));
	Если НайдСтроки.Количество() > 0 Тогда
		ЭтаФорма.Элементы.НадписьМалоеОбщееИтого.Заголовок = Строка(НайдСтроки[0].Количество);
		ЭтаФорма.Элементы.НадписьИтогоОбщее.Заголовок = "Всего в эксплуатации - " + Строка(НайдСтроки[0].Количество);
	КонецЕсли; 
	
	//Вот таким способом добиваемся того, чтобы не было курсора на 1-ой строке таблица значений
	Элементы.ПереченьТСВРемонте.ТекущаяСтрока = 0;
	Элементы.ПереченьТСВРемонте.ВыделенныеСтроки.Очистить();
	Элементы.ПереченьТСНетДанных.ТекущаяСтрока = 0;
	Элементы.ПереченьТСНетДанных.ВыделенныеСтроки.Очистить();
	//Вот таким способом добиваемся того, чтобы не было курсора на 1-ой строке таблица значений
КонецПроцедуры

&НаКлиенте
Процедура ПереключательРазделыПриИзменении(Элемент)
	ВидимостьЭлементовФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент = Неопределено)
	Если ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда //Если  меняем принудительно в форме, то и меняем "НомерТекСтрокиПодразделения". И перебор подразделений будет идти с указанного
		НомерТекСтрокиПодразделения	 = Элементы.Подразделение.СписокВыбора.Индекс(Элементы.Подразделение.СписокВыбора.НайтиПоЗначению(Подразделение));
	КонецЕсли;	
	ЗаполнитьПереченьТСВРемонтеПоПодразделению(ЭтаФорма.Подразделение);
	ЗаполнитьТаблицыПоПодразделению(ЭтаФорма.Подразделение);
	ВидимостьЭлементовФормы();
	НомерТекСтрокиНаЛинии = 0;
	НомерТекСтрокиГараж = 0;
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Функция  ПолучитьПользователяWindows()
	Network = Новый COMОбъект("WScript.Network");
	ИмяПользователяWindows    = Network.UserName;
	Возврат ИмяПользователяWindows;
КонецФункции	

&НаСервере
Процедура РаскрасимТаблицыВГаражеИВРемонте()
	
	Для Каждого ХХХ Из ПереченьГаражей Цикл 
		ЦветГаража = ХХХ.ЦветГаража;
		Если ЦветГаража <> Неопределено И ЦветГаража <> (Новый Цвет(0,0,0)) тогда
			
			Оформление  = УсловноеОформление.Элементы.Добавить();
			Оформление.Использование = Истина;
			Поле1 = Оформление.Поля.Элементы.Добавить();
			Поле1.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВГаражеГаражныйНомер");
			Поле2 = Оформление.Поля.Элементы.Добавить();
			Поле2.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВГаражеГосударственныйНомер");
			Поле3 = Оформление.Поля.Элементы.Добавить();
			Поле3.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВГаражеТС");
			Поле4 = Оформление.Поля.Элементы.Добавить();
			Поле4.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВГаражеТекущееПоложениеДата");
			Отбор = Оформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПереченьТСВГараже.Гараж");
			Отбор.ПравоеЗначение = ХХХ.Наименование; 
			Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Отбор.Использование = Истина;
			Оформление.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветГаража);	
			
			
			Оформление  = УсловноеОформление.Элементы.Добавить();
			Оформление.Использование = Истина;
			Поле1 = Оформление.Поля.Элементы.Добавить();
			Поле1.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеПолныйГаражныйНомер");
			Поле2 = Оформление.Поля.Элементы.Добавить();
			Поле2.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеПолныйГосударственныйНомер");
			Поле3 = Оформление.Поля.Элементы.Добавить();
			Поле3.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеПолныйДатаНачалаРемонта");
			Поле4 = Оформление.Поля.Элементы.Добавить();
			Поле4.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеПолныйТС");
			Поле5 = Оформление.Поля.Элементы.Добавить();
			Поле5.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеПолныйДатаОкончанияПлановая");
			Отбор = Оформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеПолный.Гараж");
			Отбор.ПравоеЗначение = ХХХ.Наименование; 
			Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Отбор.Использование = Истина;
			Оформление.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветГаража);	
			
			Оформление  = УсловноеОформление.Элементы.Добавить();
			Оформление.Использование = Истина;
			Поле1 = Оформление.Поля.Элементы.Добавить();
			Поле1.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеГаражныйНомер");
			Поле2 = Оформление.Поля.Элементы.Добавить();
			Поле2.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеГосударственныйНомер");
			Поле3 = Оформление.Поля.Элементы.Добавить();
			Поле3.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеДатаНачалаРемонта");
			Поле4 = Оформление.Поля.Элементы.Добавить();
			Поле4.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеТС");
			Поле5 = Оформление.Поля.Элементы.Добавить();
			Поле5.Поле = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонтеДатаОкончанияПлановая");
			Отбор = Оформление.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			Отбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПереченьТСВРемонте.Гараж");
			Отбор.ПравоеЗначение = ХХХ.Наименование; 
			Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
			Отбор.Использование = Истина;
			Оформление.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветГаража);	
			
			
		КонецЕсли;	
	КонецЦикла;	
КонецПроцедуры	



