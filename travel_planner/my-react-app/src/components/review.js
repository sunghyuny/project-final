import React from 'react';

function Review(props){
    return(
        <div className="review">
            <img src={props.imageUrl} alt="로컬 이미지" />
            <p>{props.locate}</p>
            <p>{props.title}</p>
            <p>{props.user}</p>
            
        </div>
    )
}

export default Review