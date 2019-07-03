



potions.utils.spawn_up = function(nodes, height, node, delay, nmax, cb)
	
	local h = 0
	local i = 1
	
	local function go()
		for n = 1,nmax do
			
			if i > #nodes then
				i = 1
				h = h + 1
				if h > height then
					if type(cb) == 'function' then
						minetest.after(0, cb)
					end
					return
				end
			end
			
			
			local p = nodes[i]
			
			minetest.set_node({x=p.x, y=p.y+h, z=p.z}, {name=node})
			
			i = i + 1 
		end
		
		minetest.after(delay, go)
	end
	
	go()
	
end


potions.utils.spawn_up_fn = function(nodes, height, node, delay, nmax, fn, cb)
	
	local h = 0
	local i = 1
	
	local function go()
		for n = 1,nmax do
			
			if i > #nodes then
				i = 1
				h = h + 1
				if h > height then
					if type(cb) == 'function' then 
						minetest.after(0, cb)
					end
					return
				end
			end
			
			
			local p = nodes[i]
			
			minetest.set_node({x=p.x, y=p.y+h, z=p.z}, {name=node})
			fn(p, node)
			
			i = i + 1 
		end
		
		minetest.after(delay, go)
	end
	
	go()
	
end







potions.utils.spawn_set_fn = function(nodes, delay, nmax, fn, cb)
	
	local i = 1
	
	local function go()
		for n = 1,nmax do
			
			if i > #nodes then
				if type(cb) == 'function' then 
					minetest.after(0, cb)
				end
				return
				
			end
			
			
			local pn = nodes[i]
			
			minetest.set_node(pn[1], pn[2])
			fn(pn[1], pn[2])
			
			i = i + 1 
		end
		
		minetest.after(delay, go)
	end
	
	go()
	
end


potions.utils.spawn_set = function(nodes, delay, nmax, cb)
	
	local i = 1
	
	local function go()
		for n = 1,nmax do
			
			if i > #nodes then
				if type(cb) == 'function' then 
					minetest.after(0, cb)
				end
				return
				
			end
			
			
			local pn = nodes[i]
			
			minetest.set_node(pn[1], pn[2])
			
			i = i + 1 
		end
		
		minetest.after(delay, go)
	end
	
	go()
	
end






