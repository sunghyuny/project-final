import React from 'react'
import "../active.css"

function Active(props){
    return(
        <div className='active'>
            <input type="checkbox" className='acitve_checkbox'></input>
            <img src={props.imageUrl} alt="로컬 이미지" />
            <div className='acitve_text'>
                <p className='active_title'>{props.title}</p>
                <p className='active_add'>{props.add}</p>
                <p className='active_time'>{props.time}</p>
                <p className='active_price'>{props.price}</p>
                <p className='acitve_ph'>{props.ph}</p>
            </div>
            
        </div>
    )
}

export default Active