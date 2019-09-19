local GAME = require "class"
print("Введите ширину поля, которое больше или равно 10")
local w = io.read()
w = tonumber(w)
while (w < 10) do
	print ("Некорректный ввод данных, введите число которое больше или равно 10")
	w = io.read()
	w = tonumber(w)
end

print("Введите высоту поля больше нуля ")
local h = io.read()
h = tonumber(h)
while (h < 0) do
	print ("Некорректный ввод данных, введите число которое больше 0")
	h = io.read()
	h = tonumber(h)
end
tir = GAME:init(w,h)
local com =""
while (string.sub(com, 1, 1)~='q') do
	tir:tick()
	tir:mix()
	tir:tick()
	tir:dump()
	print ("Введите команду в формате: m x y r, где r-направление (​l​ - left, ​r​ - right, ​u​ - up, ​d​ - down), через пробел")
	com = io.read()
	tir:move(com)
end