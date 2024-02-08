// App.js

import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import Home from './components/Home';
import About from './components/About';
import SignupForm from './components/signup';  // SignupForm 추가
import SignupFormComponent from './components/signup';

const App = () => {
  return (
    <Router>
      <div>
        {/* 네비게이션 링크 추가 */}
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/about">About</Link>
            </li>
            <li>
              <Link to="/Accounts/signup">회원가입</Link>
            </li>
            <li>
              <Link to="Accounts/login">로그인</Link>
            </li>
          </ul>
        </nav>

        {/* 라우트 설정 */}
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/Accounts/signup" element={<SignupFormComponent  />} />
          <Route path="/Accounts/login" element= {<login />} />
          {/* 다른 라우트들을 추가할 수 있습니다. */}
        </Routes>
      </div>
    </Router>
  );
};

export default App;
