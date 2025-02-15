# don-carbuild

## DESCRIPTION  

The **don-carbuild** system is a stock management solution for vehicle shops. Instead of directly adding vehicles to the store, you must **build a car step by step** before delivering it to the dealership.  

Additionally, dealers can adjust car prices, but there's a **fixed profit margin**:  

- The base price of a vehicle in `qb-core/vehicles` is increased by **30%**.  
- Example: If a car costs **$100,000** in `qb-core/vehicles`, its price in this system will be **$130,000**.  
- The dealer's profit is **$30,000** by default.  
- If the dealer offers a discount (e.g., sells for **$120,000**), their profit will be reduced accordingly (**$20,000** instead of $30,000).  

## FEATURES  

✅ Added a **vehicle catalog**  
🔗 Now using a forked script: [tn-vehiclecatalogue](https://github.com/TN-DEVV/tn-vehiclecatalogue)  
🆕 New **UI for selling vehicles**  

## INSTALLATION  

### 1️⃣ Add Items to `qb-core/shared/items`  

Insert the following items into your `qb-core/shared/items` file:  

```lua
paint_red = {name = 'paint_red', label = 'Paint Red', weight = 200, type = 'item', image = 'paint_red.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Paint for Vehicle'},
paint_white = {name = 'paint_white', label = 'Paint White', weight = 200, type = 'item', image = 'paint_white.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Paint for Vehicle'},
paint_black = {name = 'paint_black', label = 'Paint Black', weight = 200, type = 'item', image = 'paint_black.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Paint for Vehicle'},
-- (Add other colors here)
engine = {name = 'engine', label = 'Vehicle Engine', weight = 200, type = 'item', image = 'engine.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Vehicle Engine'},
transmission = {name = 'transmission', label = 'Vehicle Transmission', weight = 200, type = 'item', image = 'transmission.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Vehicle Transmission'},
wheel = {name = 'wheel', label = 'Vehicle Wheel', weight = 200, type = 'item', image = 'wheel.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Vehicle Wheel'},
brake = {name = 'brake', label = 'Vehicle Brake', weight = 200, type = 'item', image = 'brake.png', unique = false, useable = true, shouldClose = true, combinable = nil, description = 'Vehicle Brake'},
```

### 2️⃣ SQL Database Setup  

- If you are using `qb-vehicleshop`, you **DO NOT** need to import `vehshop.sql`.  
- If you are **not** using `qb-vehicleshop`, **import both** `vehshop.sql` and `sql.sql`.  

### 3️⃣ Add Item Images to Your Inventory Script  

Make sure to add all item images (`.png` files) to your inventory script's images folder.  

### 4️⃣ Remove Other Vehicle Shop Scripts  

Before installing this system, **delete any other vehicle shop scripts** to avoid conflicts. Then, **drag and drop this script** into your resources folder.  

## Notes  

⚠️ Make sure all images for new items are correctly placed in the inventory script's images folder.  
⚠️ If you encounter issues, check that **all database imports are done correctly**.  
