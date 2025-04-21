import { getNameMonth } from "../utils/utils"

// Mock de datos inicial
const mockData = [
    { id: 1, fdate: "2022-01-15", month: 0, year: 2022, category: "market", amount: 150.25 },
    { id: 2, fdate: "2022-02-10", month: 1, year: 2022, category: "fuel", amount: 80.00 },
    { id: 3, fdate: "2022-03-05", month: 2, year: 2022, category: "others", amount: 35.75 },
    { id: 4, fdate: "2023-01-20", month: 0, year: 2023, category: "market", amount: 200.50 },
    { id: 5, fdate: "2023-04-15", month: 3, year: 2023, category: "fuel", amount: 60.30 },
    { id: 6, fdate: "2023-07-18", month: 6, year: 2023, category: "others", amount: 40.15 },
    { id: 7, fdate: "2024-02-12", month: 1, year: 2024, category: "market", amount: 170.85 },
    { id: 8, fdate: "2024-08-25", month: 7, year: 2024, category: "fuel", amount: 120.00 },
    { id: 9, fdate: "2024-11-30", month: 10, year: 2024, category: "others", amount: 55.50 },
    { id: 10, fdate: "2022-05-14", month: 4, year: 2022, category: "market", amount: 300.75 },
    { id: 11, fdate: "2023-09-21", month: 8, year: 2023, category: "fuel", amount: 90.40 },
  ]

let inMemoryDB = [...mockData] // Base de datos en memoria

export const getListAmount = async () => {
  return inMemoryDB
}

export const deleteAmount = async (id) => {
  inMemoryDB = inMemoryDB.filter((item) => item.id !== id)
}

export const addAmount = async (data) => {
  if (!data || !data.id || !data.fdate || !data.month || !data.year || !data.category || !data.amount) {
    throw new Error("Datos incompletos para agregar una transacción.")
  }
  inMemoryDB.push(data)
}

export const getListByCategory = async (category, monthIndex) => {
  const monthName = getNameMonth(monthIndex)
  return inMemoryDB.filter(
    (item) => item.category === category && item.month === monthName
  )
}

export const getTotalAmountByCategory = async () => {
  const groupedData = {}

  inMemoryDB.forEach((item) => {
    const yearMonth = `${item.year}-${item.month}`
    if (!groupedData[yearMonth]) {
      groupedData[yearMonth] = {
        Year: item.year,
        Month: item.month,
        Super: 0,
        Gasoil: 0,
        Otros: 0,
        Total: 0,
      }
    }

    if (item.category === "market") groupedData[yearMonth].Super += item.amount
    if (item.category === "fuel") groupedData[yearMonth].Gasoil += item.amount
    if (item.category === "others") groupedData[yearMonth].Otros += item.amount

    groupedData[yearMonth].Total += item.amount
  })

  return Object.values(groupedData)
}
