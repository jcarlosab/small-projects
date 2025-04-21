const InputValue = ({ inputValue, handleAddAmount, handleInputChange }) => {
    return (
        <div className='add-number d-flex'>
          <input
            className='add-number_input'
            type='text'
            inputMode='decimal'
            value={inputValue.replace(',', '.')}
            onKeyDown={(e) => e.key === 'Enter' && handleAddAmount()}
            onChange={handleInputChange}
            placeholder='0.00'
          />
          <button
            className='button button--primary '
            onClick={handleAddAmount}
            disabled={!inputValue}
          >
            Añadir
          </button>
      </div>
    )
}

export default InputValue
