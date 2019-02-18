// pages/scanCode/scanCode.js
Page({

  /**
   * 页面的初始数据
   */
  data: {

  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    setTimeout(function () {
      wx.scanCode({//调用扫一扫
        success: function (res) {//扫码成功的回调函数
          wx.redirectTo({//失败的话，重定向到页面中，并且携带miniType参数和result参数
            url: '../index/index?url=https://www.hxkj.vip?miniType=mini&result=' + res
          })
        },
        error: function (err) {//扫码失败的回调函数
          console.log('err');
          wx.redirectTo({//失败的话，直接重定向到页面，并且不带任何参数
            url: '../index/index?url=https://www.hxkj.vip/'
          })
        }
      })
    }, 500)
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {

  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {

  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {

  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {

  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {

  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {

  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {

  }
})