import React from 'react';
<<<<<<< HEAD
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import './App.css'
import Home from './pages/Main/Home.js';
import About from './components/About';
import SignupFormComponent from './pages/Accounts/signup';
import Loginform from './pages/Accounts/login';
=======
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from './pages/Main/Home'
import Signup from './pages/Accounts/Sigup';
import Schedule from './pages/Planner/schedule';
import Location from './pages/Planner/location';
import Lodging from './pages/Planner/lodging';
import Activity from './pages/Planner/activity';
import Summary from './pages/Planner/summary';


>>>>>>> e58833f4e11e4f16f70ca1dbf23e08a4f51cf9d3

const App = () => {
  return (
    <Router>
<<<<<<< HEAD
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
              <Link to="/Accounts/login">로그인</Link>
            </li>
          </ul>
        </nav>

        {/* 라우트 설정 */}
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          <Route path="/Accounts/signup" element={<SignupFormComponent  />} />
          <Route path="/Accounts/login" element= {<Loginform />} />
          {/* 다른 라우트들을 추가할 수 있습니다. */}
=======
        {/* 라우트 설정 */}
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/pages/Signup" element={<Signup/>} />
          {/* 여행계획세우기 */}
          <Route path="/planner/schedule" element={<Schedule/>}/>
          <Route path="/planner/location" element={<Location/>}/>
          <Route path="/planner/lodging" element={<Lodging/>}/>
          <Route path="/planner/activity" element={<Activity/>}/>
          <Route path="/planner/summary" element={<Summary/>}/>
>>>>>>> e58833f4e11e4f16f70ca1dbf23e08a4f51cf9d3
        </Routes>
    </Router>


  );
};

export default App;