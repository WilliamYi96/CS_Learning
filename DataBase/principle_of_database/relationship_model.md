# 基本概念
## 关于关系模型
关系模型是逻辑模型中的一种，也是现在普遍使用的一种。其由实体、属性和关系三者构成。其可以使用一张二维表进行关系呈现。

关系模型由数据结构、数据操作和完整性约束三部分构成。其中数据结构是指数据自身的组织形式；数据操作是指对数据进行的增删改查的操作，而对数据的查询是该模型中最为重要的操作；完整性约束是指满足现实条件的数据值的范围等。

关系查询操作根据其理论基础的不同，可以分为关系代数和关系演算两大类。其中，关系代数是以集合论为基础发展而来的，关系演算是以谓词逻辑为基础发展而来的。
关系代数的主要操作包括选择、投影、连接等关系专用操作和交、并、差等通用的集合操作；关系演算按照其谓词变量的不同又分为元组关系演算和域关系演算。
其中，关系代数与安全的元组关系演算和安全的域关系演算之间是等价的。

## 关系的定义
**关系就是由域通过笛卡尔积构成的集合上的子集。**

关系在二维数表中进行呈现，其中每一列表示的是一个**属性**，而除了属性标识列的每一行都被称之为一个**元组**。

**关系中的各种键**
超键：能够唯一确定一个元组的一个或者多个属性集；
主键(候选键):  将超键中某些冗余的属性去掉之后的最小完备集合；
外键：如果关系R1的某个属性集是关系R2的候选键；则称属性集对于R1而言是其外键；

值得注意的是，超键中可能存在冗余的属性集，也就是说去掉超键中的部分属性也可以唯一标识一个元组。

## 关系模式
关系模式是对关系的型的描述，也就是说关系模式是关系的实例化。举例来说，如果关系是一个空货架，那么关系模式就是装满书的货架。

## 关系的完整性
关系的完整性规则由域完整性约束、实体完整性约束、参照完整性约束、用户完整性约束四个部分构成。

### 域完整性约束
其主要约束两点：一则为元组分量能够在某一属性之下取空值；二则为元组分量在某一属性下的取值是否在其值域之内。

### 实体完整性约束
实体完整性约束又被称之为主键约束。其要求元组在键上的取值不能重复，同时也不能为空。

### 参照完整性约束
参照完整性约束又被称之为外键约束。其要求关系中不允许引用不存在的实体。如果属性集A为关系R的外键，属性集B为关系S的主键，当A对B进行引用时，其值要么等于关系S上某元组在主键上的值，要么取空值。
关于其概念理解不是太清晰，后续进行细致分析。

### 用户完整性约束
根据实际应用领域的关系模式进行的语义限制。例如人的年龄是递增的，而仓库的库存必须大于出货量等。

# 关系代数
## 关系运算符
关系代数中运算对象是关系，运算结果也是关系。
关系运算符分为以下几种：

- 集合运算符: 交并差，笛卡尔叉积
- 专门运算符: 选择，投影，连接，除
- 算术运算符
- 逻辑运算符: 与或非

关于具体的关系代数的定义以及使用情况，参见课本以及PPT相关内容。
# 关系演算
关系演算是以数理逻辑中的谓词演算为基础的。按谓词变元的分类，关系演算可以分为元组关系演算和域关系演算。其中元组关系演算以元组变量作为谓词变元的基本对象，域关系演算以域变量作为谓词变元的基本对象。

**安全表达式**
无限关系和无穷验证在计算机中都是不允许出现的，我们将不产生无限关系和无穷验证的表达式称为安全表达式，为了保证运算的安全性而采取的限制措施称为安全约束。

并、差、笛卡尔叉积、投影和选择是关系代数最基本的操作，并构成了关系代数运算的最小完备集。
已经证明，在这个基础上，关系代数、安全的元组关系演算、安全的域关系演算在关系的表达和操作能力上是完全等价的。
