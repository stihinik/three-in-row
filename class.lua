local GAME = {}
math.randomseed(os.time())
--в данной функции генерируется игровое поле, размеры которого задает сам пользователь 
function GAME:init (w,h)
	local private ={}
		private.cristal = {'A','B','C','D','E','F'}
		private.game ={} 
		private.my_w = w
		private.my_h = h
		for i=1,private.my_h do
			   private.game[i]={}          
			   for j=1,private.my_w do
				 local nomber = math.random(1,6)
				private.game[i][j]=private.cristal[nomber]
			   end   
		end
	
	setmetatable(private,self)
    self.__index = self; return private
end
-- вывод игрового поля в консоль
function GAME:dump()
	str ="   "
	-- добавляем нумерацию игрового поля 
	for i=0,self.my_w-1 do
		if i<10 then
			str = str..i.."  "
		else
			str = str..i.." "
		end
	end 
	print(str)
	for i=1,self.my_h do
		if i <= 10 then
			str = (i-1).."  " 
		else
			str = (i-1).." "
		end        
		for j=1,self.my_w do
			str = str..self.game[i][j].."  "
		end
		print(str)   
	end
end 
-- перемещение объектов в игровом поле, командами поступающими от игрока
function GAME:move(com)
	if (string.sub(com, 1, 1)=='m' and string.sub(com, 2, 2)==' ') then
		begin_str = string.find(com," ")
		com = string.gsub(com, "%s+","",1)
		end_str = string.find(com," ")
		x = tonumber(string.sub(com, begin_str, end_str))+1
		
		begin_str = end_str
		com = string.gsub(com, "%s+","",1)
		end_str = string.find(com," ")
		y = tonumber(string.sub(com, begin_str, end_str))+1
		
		begin_str = end_str
		end_str = string.len(com)
		col = string.sub(com, begin_str, end_str)
		col = string.gsub(col, "%s+","")
		
		step = self.game[y][x]
		if (col=="l") and x~=1 then
			self.game[y][x] = self.game[y][x-1]
			self.game[y][x-1] = step
			x=x-1
		elseif (col=="r") and x~=self.my_w then
			self.game[y][x] = self.game[y][x+1]
			self.game[y][x+1] = step
			x=x+1
		elseif (col=="u") and y~=1 then
			self.game[y][x] = self.game[y-1][x]
			self.game[y-1][x] = step
			y=y-1
		elseif (col=="d") and y~=self.my_h then
			self.game[y][x] = self.game[y+1][x]
			self.game[y+1][x] = step
			y=y+1
		else 
			print ("Некорректный ввод данных")
		end
	elseif(string.sub(com, 1, 1)~='q')then
		print ("Некорректный ввод данных")
	end
end
-- проверка находится ли в игровом поле три и более подряд одинаковых элементов
function GAME:tick()
	for i=1,self.my_h do
		for j=1,self.my_w do
			flag = true
			flag_x = 0
			flag_y = 0
			while flag == true do
				if (((j+flag_x)<=self.my_w+1) and ((i+flag_y)<=self.my_h))then
					if (self.game[i][j]==self.game[i][j+flag_x] and (j+flag_x)<=self.my_w) then
						flag_x=flag_x+1
					elseif (self.game[i][j]==self.game[i+flag_y][j]and(i+flag_y)<=self.my_h) then
						flag_y=flag_y+1
					else 
						flag =false
					end
				else 
					flag =false
				end
			end 
			-- удаление одинаковых элементов вдоль оси x
			if (flag_x>=3) then
			   for k=0,flag_x-1 do
				for step = i,2,-1 do
					self.game[step][j+k] = self.game[step-1][j+k]
				end
					local nomber = math.random(1,6)
					self.game[1][j+k]=self.cristal[nomber]
			   end
			end
			-- удаление одинаковых элементов вдоль оси y
			if (flag_y>=3) then
				for step = (i+(flag_y-1)),(flag_y+1),-1 do
					self.game[step][j] = self.game[step-(flag_y)][j]
				end
				for k=1,flag_y do
					local nomber = math.random(1,6)
					self.game[k][j]=self.cristal[nomber]
				end
			end
		end  
	end
end
-- проверяет есть в игром поле возможные ходы
function GAME:mix()
	flag = true
	while flag do
		for i=1,self.my_h do
			for j=1,self.my_w do
				--если игровое поле больше двух
				if self.my_h>2 then
					flag_1_x =(j+2<=self.my_w and i+1<=self.my_h and i-1>0)and(self.game[i][j] == self.game[i][j+2]) and ((self.game[i][j] == self.game[i+1][j+1])or(self.game[i][j] == self.game[i-1][j+1]))
					flag_2_x =(j+3<=self.my_w and i+1<=self.my_h and i-1>0)and(self.game[i][j] == self.game[i][j+1]) and ((self.game[i][j] == self.game[i][j+3])or(self.game[i][j] == self.game[i-1][j+2])or(self.game[i][j] == self.game[i+1][j+2]))
					flag_3_x =(i+1<=self.my_h and i-1>0 and j-2>0)and(self.game[i][j] == self.game[i][j+1]) and ((self.game[i][j] == self.game[i][j-2])or(self.game[i][j] == self.game[i-1][j-1])or(self.game[i][j] == self.game[i+1][j-1]))
					flag_1_y =(j+1<=self.my_w and i+2<=self.my_h and j-1>0)and(self.game[i][j] == self.game[i+2][j]) and ((self.game[i][j] == self.game[i+1][j+1])or(self.game[i][j] == self.game[i+1][j-1]))
					flag_2_y =(i+3<=self.my_h and j-1>0 and j+1<=self.my_h)and(self.game[i][j] == self.game[i+1][j]) and ((self.game[i][j] == self.game[i+3][j])or(self.game[i][j] == self.game[i+2][j+1])or(self.game[i][j] == self.game[i+2][j+1]))
					flag_3_y =(j+1<=self.my_w and i-2>0 and j-1>0)and(self.game[i][j] == self.game[i+1][j]) and ((self.game[i][j] == self.game[i-2][j])or(self.game[i][j] == self.game[i-1][j-1])or(self.game[i][j] == self.game[i-1][j+1]))
					if flag_1_x or flag_1_y or flag_2_x or flag_2_y or flag_3_x or flag_3_y then
						flag = false
						break
					end
				--если игровое поле меньше или равно двум 
				else
					flag_1 =(j+3<=self.my_w and j-2>0)and(self.game[i][j] == self.game[i][j+1]) and ((self.game[i][j] == self.game[i][j+3])or(self.game[i][j] == self.game[i][j-2]))
					flag_2 =(i+1<=self.my_h  and j+2<=self.my_w)and(self.game[i][j] == self.game[i][j+2]) and (self.game[i][j] == self.game[i+1][j+1])
					flag_3 =(i+1<=self.my_h and j+2<=self.my_w)and(self.game[i][j] == self.game[i][j+1]) and (self.game[i][j] == self.game[i+1][j+2])
					flag_2 =(i-1>0  and j+2<=self.my_w)and(self.game[i][j] == self.game[i][j+2]) and (self.game[i][j] == self.game[i-1][j+1])
					flag_3 =(i-1>0 and j+2<=self.my_w)and(self.game[i][j] == self.game[i][j+1]) and (self.game[i][j] == self.game[i-1][j+2])
					if flag_1 or flag_2 or flag_3 or flag_4 or flag_5 then 
						flag = false
						break
					end
				end 
			end  
			if not flag then
				break
			end
		end
		--генерация нового игрового поля если ходы не найдены
		if flag then
			for i=1,self.my_h do          
				for j=1,self.my_w do
					local nomber = math.random(1,6)
					self.game[i][j]=self.cristal[nomber]
				end   
			end
		end
	end
end
return GAME