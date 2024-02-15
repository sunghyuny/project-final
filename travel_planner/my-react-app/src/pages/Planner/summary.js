import React from 'react';
import Navbar from '../../components/navbar';


function Summary(){
    return(
        <div>
            <Navbar/>
            <div className="progress">
                <div className='Fill_Circle'>
                    <p>기간/<br></br>인원</p>
                </div>
                <div className='Fill_Circle'>
                    <p>여행지</p>
                </div>
                <div className='Fill_Circle'>
                    <p>숙소</p>
                </div>
                <div className='Fill_Circle'>
                    <p>활동</p>
                </div>
                <div className='Fill_Circle'>
                    <p>요약</p>
                </div>
            </div>
            <button className='save_btn'>저장</button>
            <button className='share_btn'>공유</button>
            <button className='print_btn'>출력</button>
        </div>    
    )
}
export default Summary