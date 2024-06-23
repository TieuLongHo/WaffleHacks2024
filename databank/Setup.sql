DROP TABLE IF EXISTS FoodTruck CASCADE;
DROP TABLE IF EXISTS Event CASCADE;
DROP TABLE IF EXISTS FoodTruck_Event CASCADE;
DROP TABLE IF EXISTS Dish CASCADE;

CREATE TABLE FoodTruck (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    info TEXT,
    event_ids INT[] DEFAULT '{}'::INT[]
);

CREATE TABLE Event (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

CREATE TABLE FoodTruck_Event (
    id SERIAL PRIMARY KEY,
    foodtruck_id INT,
    event_id INT,
    longitude DOUBLE PRECISION,
    latitude DOUBLE PRECISION,
    FOREIGN KEY (foodtruck_id) REFERENCES FoodTruck(id),
    FOREIGN KEY (event_id) REFERENCES Event(id)
);

CREATE TABLE Dish (
    id SERIAL PRIMARY KEY,
    truck_id INT REFERENCES FoodTruck(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    price FLOAT NOT NULL,
    ingredients TEXT[] DEFAULT '{}'::TEXT[]
);



INSERT INTO FoodTruck (name, info, event_ids) VALUES ('Tasty Truck', 'Gourmet food on wheels', '{1, 2}');
INSERT INTO Dish (truck_id, name, price, ingredients) VALUES
(1, 'Burger', 9.99, ARRAY['beef patty', 'lettuce', 'tomato', 'cheese', 'bun']),
(1, 'Fries', 3.99, ARRAY['potatoes', 'salt', 'oil']),
(1, 'Taco', 5.99, ARRAY['tortilla', 'beef', 'lettuce', 'cheese', 'salsa']),
(1, 'Salad', 4.99, ARRAY['lettuce', 'tomato', 'cucumber', 'olive oil', 'vinegar']);

INSERT INTO Event (name, start_date, end_date) VALUES ('Food Festival', '2024-07-01', '2024-07-03');
INSERT INTO Event (name, start_date, end_date) VALUES ('Street Fair', '2024-08-15', '2024-08-20');

INSERT INTO FoodTruck_Event (foodtruck_id, event_id, longitude, latitude) VALUES (1, 1, 7.729164431958253, 46.76264953467455);
INSERT INTO FoodTruck_Event (foodtruck_id, event_id, longitude, latitude) VALUES (1, 2, 8.309161313617295, 47.05408208349266);


SELECT * FROM FoodTruck;
SELECT * FROM Dish;
SELECT * FROM Event;
SELECT * FROM FoodTruck_Event;