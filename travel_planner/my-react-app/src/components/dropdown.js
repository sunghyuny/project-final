import React from 'react';

function Dropdown({ items, onItemClick }) {
    return (
        <div className="dropdown-menu">
            {items.map((item, index) => (
                <div key={index} className="dropdown-item" onClick={() => onItemClick(item)}>
                    {item}
                </div>
            ))}
        </div>
    );
}

export default Dropdown;
