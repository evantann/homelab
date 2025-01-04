import React, { useState, useEffect } from 'react';

const App = () => {
    const [items, setItems] = useState([]);
    const [itemName, setItemName] = useState('');

    useEffect(() => {
        fetchItems();
    }, []);

    const fetchItems = async () => {
        try {
            const response = await fetch('/items');
            if (!response.ok) {
                throw new Error('Failed to fetch items');
            }
            const data = await response.json();
            setItems(data);
        } catch (error) {
            console.error('Error fetching items:', error);
        }
    };

    const addItem = async () => {
        try {
            const response = await fetch('/items', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name: itemName }),
            });

            if (!response.ok) {
                throw new Error('Failed to add item');
            }

            const newItem = await response.json();
            setItems([...items, newItem]);
            setItemName('');
        } catch (error) {
            console.error('Error adding item:', error);
        }
    };

    return (
        <div style={{ padding: '20px' }}>
            <h1>Item List</h1>
            <input
                type="text"
                value={itemName}
                onChange={(e) => setItemName(e.target.value)}
                placeholder="Enter item name"
            />
            <button onClick={addItem}>Add Item</button>
            <ul>
                {items.map((item) => (
                    <li key={item.id}>{item.name}</li>
                ))}
            </ul>
        </div>
    );
};

export default App;
