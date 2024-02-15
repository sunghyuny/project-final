import React from 'react'
import "../lodg.css"

function Lodg(props){
    return(
        <div className="lodg">
            <img src={props.imageUrl} alt="로컬 이미지" />
            <p className='lodg_title'>{props.title}</p>
            <p className='lodg_locate'>{props.locate}</p>
            <p className='lodg_price'>{props.price}</p><br></br>
            <p className='lodg_scope'>{props.scope}</p>
            <p className='lodg_review'>{props.review}</p>
            <input type='checkbox' className='lodg_check'></input>
        </div>
    )
}

export default Lodg