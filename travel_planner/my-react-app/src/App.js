import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from './pages/Main/Home'
import Signup from './pages/Accounts/Sigup';
import Schedule from './pages/Planner/schedule';
import Location from './pages/Planner/location';
import Lodging from './pages/Planner/lodging';
import Activity from './pages/Planner/activity';
import Summary from './pages/Planner/summary';



const App = () => {
  return (
    <Router>
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
        </Routes>
    </Router>


  );
};

export default App;