## 核心要点
### **computer organization 和 computer architecture的比较**

||可见性|设计方式|
|---|---|---|
|Organization|性质被系统设计者(system designer)可见|逻辑设计的一种实现(an implementation)|
|Architecture|性质被编程者(programmer)可见|计算机的逻辑设计(logic design)|

### **Transparency 基本概念**

对于存在的事物或者某些性质，从一个视角来看，它们就像不存在一样。就比如说，我们知道QQ收发消息过程经过了复杂的操作，但是从用户角度来看，只看到了消息的收发，复杂的信息传递方式以及协议就好像不存在一样。

### **Compatibility 基本概念**

兼容性包含向上兼容和向后兼容两方面的内容。向上兼容是指较为低级的计算机能够不加修改地在较为高级的计算机上运行；向后兼容指的是当前的程序可以不加修改的在未来的程序上运行。

值得注意的是，上述两种兼容性的表述仅仅针对的是同一种结构的计算机，也就是序列机。

**序列机(Sequence Machine)**: 相同architecture而不同organization的计算机的集合。

### **computer structure 和 computer functions 基本概念**

- structure. 不同组分(components)之间交互的方式(the way in which the components are related to each other).

- function. structure中的每个组分的操作(the operation of each individual compoent as part of the structure).

computer function 包含如下四个方面的内容：

- 数据处理(Data Processing)
- 数据存储(Data Storage)
- 数据转移(Data Movement)
- 控制(control)

### **一个normal computer 的主要构成(main components)**以及**CPU 和 CU的主要构成**

![](./img/computer.png)

## 问题
冯诺依曼机的理解掌握程度，IAS计算机结构的扩展掌握程度
