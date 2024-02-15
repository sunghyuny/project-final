import React from "react";

function Signup(){
    return(
        <div className='Login_container'>
            <div className='page_title'>
                <h3>로그인</h3>
                <hr></hr>
            </div>
            <div className='Login_contents'>
                <input type='test' placeholder="아이디"></input><br></br>
                <input type='password' placeholder="비밀번호"></input>
                <button type='submit' className='login_button'>로그인</button>
                <button>회원가입</button>
                <button>아이디/비번찾기</button>
            </div>
        </div>
    )
}
export default Signup;