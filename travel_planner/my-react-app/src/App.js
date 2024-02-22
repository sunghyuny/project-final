import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { UserProvider } from './components/UserContext'; // UserProvider import 추가
import Home from './pages/Main/Home';
import Login from './pages/Accounts/login';
import Schedule from './pages/Planner/Schedule';
import Location from './pages/Planner/Location';
import Lodging from './pages/Planner/Lodging';
import Activity from './pages/Planner/Activity';
import Summary from './pages/Planner/Summary';
import Signup from './pages/Accounts/Signup';
import LoginStaus from './components/loginstaus';
import Sights from './pages/Sightseeing/sights';
import Search from './pages/Sightseeing/search';

const App = () => {
  return (
    <Router>
      <UserProvider> {/* UserProvider 추가 */}
        {/* 라우트 설정 */}
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/Accounts/login" element={<Login />} />
          <Route path="/Accounts/signup" element={<Signup />} />
          {/* 여행계획세우기 */}
          <Route path="/planner/schedule" element={<Schedule />} />
          <Route path="/planner/location" element={<Location />} />
          <Route path="/planner/lodging" element={<Lodging />} />
          <Route path="/planner/activity" element={<Activity />} />
          <Route path="/planner/summary" element={<Summary />} />
          <Route path="/Accounts/loginstatus" element={<LoginStaus />} />
          <Route path="/Sightseeing/Sights" element={<Sights/>}/>
          <Route path="/Sightseeing/Sights/search" element={<Search/>}/>
        </Routes>
      </UserProvider> {/* UserProvider 닫는 태그 추가 */}
    </Router>
  );
};

export default App;
